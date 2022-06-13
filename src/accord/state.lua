local replicatedStorage = game:GetService("ReplicatedStorage")

local signal = require(replicatedStorage.Packages.fastsignal)

local types = require(script.Parent.types)
local config = require(script.Parent.config)

local module = {} :: types.State

function module:__newindex(key, value)
    if rawget(self, "_methods")[key] or module[key] then
        if typeof(module[key]) == "function" then
            return self[key](self, value)

        elseif rawget(self, "_methods")[key] then
            rawset(self, key, value)
            return
        end
    end

    rawset(rawget(self, "_methods"), key, function(self: types.State, ...)
        local _lastValue = self.value

        local success, errorMessage = pcall(value, self, ...)

        if not success and not config["SILENCE_ERRORS"] then
            task.spawn(function()
                error(errorMessage, 0)
            end)
        end

        if self.value ~= _lastValue then
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

    return module[key]
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