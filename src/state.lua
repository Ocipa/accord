local HttpService = game:GetService("HttpService")
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

    rawset(rawget(self, "_methods"), key, function(self: types.State, ...)
        local _lastValue = DeepClone(self.value)

        local success, errorMessage = pcall(value, self, ...)

        if not success and not config["SILENCE_ERRORS"] then
            task.spawn(function()
                error(errorMessage, 0)
            end)
        end

        if success and (not config.CHECK_IS_EQUAL_BEFORE_UPDATE or not isEqual(self.value, _lastValue)) then
            table.insert(self._history, 1, {
                Size = #HttpService:JSONEncode(_lastValue),
                Value = _lastValue
            } :: types.HistoryValue)

            self._historySize += self._history[1].Size

            while #self._history > math.max(config.MAX_HISTORY_LENGTH, 1) do
                self._historySize -= self._history[#self._history].Size
                table.remove(self._history, #self._history)
            end

            while self._historySize > config.MAX_HISTORY_SIZE and #self._history > 1 do
                self._historySize -= self._history[#self._history].Size
                table.remove(self._history, #self._history)
            end

            self._signal:Fire(self.value, self._history[1].Value)
            require(script.Parent)._signal:Fire(self._stateName, self.value, self._history[1].Value)
        end
    end)
end

function module:__index(key)
    if rawget(self, "_methods")[key] then
        return rawget(self, "_methods")[key]
    end

    return if typeof(module[key]) == "function" then module[key] else rawget(self, key)
end


--[[
    Gets the value of the state.

    ```lua
    accord.Balance:GetValue()
    ```
]]
---@return any
function module:GetValue()
    return self.value
end


--[[
    Connects a callback to when the state value changes.

    ```lua
    accord.Balance:Connect(function(value, lastValue)
        print(("Balance changed from %s to %s"):format(lastValue, value))
    end)
    ```
]]
---@param callback fun()
---@return any
function module:Connect(callback)
    return self._signal:Connect(callback)
end


--[[
    Connects a callback to when the state value changes once.

    ```lua
    accord.Balance:ConnectOnce(function(value, lastValue)
        print(("Balance changed from %s to %s"):format(lastValue, value))
    end)
    ```
]]
---@param callback fun()
---@return any
function module:ConnectOnce(callback)
    return self._signal:ConnectOnce(callback)
end


--[[
    Disconnects all connections to the state.

    ```lua
    accord.Balance:DisconnectAll()
    ```
]]
---@return nil
function module:DisconnectAll()
    self._signal:DisconnectAll()

    return nil
end


--[[
    Destroys the state, disconnecting the connections and removing the value.

    ```lua
    accord.Balance:Destroy()
    ```
]]
---@return nil
function module:Destroy()
    -- NOTE: destroy the state from accord so that accord's index of this state
    -- is also removed
    require(script.Parent):DestroyState(self._stateName)

    return nil
end

function module._new(stateName, defaultValue)
    local self = setmetatable({}, module) :: types.State

    rawset(self, "_stateName", stateName)

    rawset(self, "_historySize", #HttpService:JSONEncode(defaultValue))
    rawset(self, "_history", {defaultValue})
    rawset(self, "value", defaultValue)

    rawset(self, "_signal", signal.new())
    rawset(self, "_methods", {})

    return self
end

return module