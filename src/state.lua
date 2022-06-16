local replicatedStorage = game:GetService("ReplicatedStorage")

local signal = require(script.Parent.Parent.fastsignal)

local types = require(script.Parent.types)
local config = require(script.Parent.config)

local module = {
    _lastValue = 0,
    value = 0
} :: types.State

local function isEqual(v1, v2)
    if typeof(v1) ~= typeof(v2) then
        return false
    end

    local t = nil
    t = {
        table = function(val1, val2)
            if typeof(val1) ~= typeof(val2) then
                return false
            end

            local bool = true
            local indexs = {}

            for i, v in val1 do
                indexs[i] = v
            end

            for i, v in val2 do
                indexs[i] = v
            end

            for i, v in indexs do
                bool = if t[typeof(v)] then t[typeof(v)](val1[i], val2[i]) else t["default"](val1[i], val2[i])

                if not bool then
                    return false
                end
            end

            return bool
        end,

        default = function(val1, val2)
            return val1 == val2
        end
    }

    return if t[typeof(v1)] then t[typeof(v1)](v1, v2) else t["default"](v1, v2)
end

local function DeepClone(val)
    local t = nil
    t = {
        table = function(val)
            local new = {}

            for i, v in val do
                new[i] = if t[typeof(v)] then t[typeof(v)](v) else t["default"](v)
            end

            return new
        end,

        default = function(val)
            return val
        end
    }

    return if t[typeof(val)] then t[typeof(val)](val) else t["default"](val)
end

function module:__newindex(key, value)
    if module[key] then
        if typeof(module[key]) == "function" then
            return rawget(self, key)(self, value)

        else
            rawset(self, key, value)
            return
        end
    end

    if rawget(self, "_methods")[key] or module[key] then
        if typeof(module[key]) == "function" then
            return self[key](self, value)

        elseif rawget(module, key) then
            rawset(self, key, value)
            return
        end
    end

    rawset(rawget(self, "_methods"), key, function(self: types.State, ...)
        local _lastValue = if config.CLONE_VALUE_TO_LAST_VALUE then DeepClone(self.value) else self.value

        local success, errorMessage = pcall(value, self, ...)

        if not success and not config["SILENCE_ERRORS"] then
            task.spawn(function()
                error(errorMessage, 0)
            end)
        end

        if not config.CHECK_IS_EQUAL_BEFORE_UPDATE or not isEqual(self.value, _lastValue) then
            self._lastValue = _lastValue

            self._signal:Fire(self.value, self._lastValue)
            require(script.Parent)._signal:Fire(self._stateName, self.value, self._lastValue)
        end
    end)
end

function module:__index(key)
    if rawget(self, "_methods")[key] then
        return rawget(self, "_methods")[key]
    end

    return if typeof(module[key]) == "function" then module[key] else rawget(self, key)
end

function module:GetValue()
    return self.value
end

function module:Connect(callback)
    return self._signal:Connect(callback)
end

function module:ConnectOnce(callback)
    return self._signal:ConnectOnce(callback)
end

function module:DisconnectAll()
    self._signal:DisconnectAll()
end

function module:Destroy()
    -- NOTE: destroy the state from accord so that accord's index of this state
    -- is also removed
    require(script.Parent):DestroyState(self._stateName)

    return nil
end

function module._new(stateName, defaultValue)
    local self = setmetatable({}, module) :: types.State

    rawset(self, "_stateName", stateName)

    rawset(self, "_lastValue", defaultValue)
    rawset(self, "value", defaultValue)

    rawset(self, "_signal", signal.new())
    rawset(self, "_methods", {})

    return self
end

return module