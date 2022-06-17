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
        local success, errorMessage = pcall(value, self, ...)

        if not success and not config["SILENCE_ERRORS"] then
            task.spawn(function()
                error(errorMessage, 0)
            end)
        end

        local CHECK_EQUAL = config.CHECK_IS_EQUAL_BEFORE_UPDATE
        if success and (not CHECK_EQUAL or not isEqual(self.value, self._history[self._historyIndex].Value)) then
            table.insert(self._history, self._historyIndex, {
                Size = if self.value then #HttpService:JSONEncode(self.value) else 0,
                Value = DeepClone(self.value)
            } :: types.HistoryValue)

            self._historySize += self._history[self._historyIndex].Size

            for i=self._historyIndex - 1, 1, -1 do
                self._historySize -= self._history[i].Size
                table.remove(self._history, i)
            end
            self._historyIndex = 1

            while #self._history > math.max(config.MAX_HISTORY_LENGTH, 2) do
                self._historySize -= self._history[#self._history].Size
                table.remove(self._history, #self._history)
            end

            while self._historySize > config.MAX_HISTORY_SIZE and #self._history > 2 do
                self._historySize -= self._history[#self._history].Size
                table.remove(self._history, #self._history)
            end

            self._signal:Fire(self:GetValue(), self:GetLastValue())
            require(script.Parent)._signal:Fire(self._stateName, self:GetValue(), self:GetLastValue())
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
    return self._history[self._historyIndex].Value
end


--[[
    Gets the last value of the state.

    ```lua
    accord.Balance:GetLastValue()
    ```
]]
---@return any
function module:GetLastValue()
    return self._history[math.clamp(self._historyIndex + 1, 1, #self._history)].Value
end


--[[
    Rescinds the value of the state. If the num is negative, goes back in the\
    value history, if num is positive, goes forward in value history, if nil,\
    goes to the last history (the most recent value change).

    ```lua
    function accord.balance:Inc()
        self.value += 2
    end

    accord.balance:Inc() -- balance = 2
    accord.balance:Inc() -- balance = 4
    accord.balance:Inc() -- balance = 6

    accord.balance:RelativeRescind(-2) -- balance = 2
    accord.balance:RelativeRescind() -- balance = 6
    ```
]]
---@param num number | nil
function module:RelativeRescind(num)
    assert(
        typeof(num) == "number" or typeof(num) == "nil",
        ("[ERROR]: state RelativeRescind: expected num to be of type number or nil, got %s"):format(typeof(num))
    )

    if num == 0 then return end

    if not num then
        self._historyIndex = 1

    else
        self._historyIndex = math.clamp(self._historyIndex - num, 1, #self._history)
    end

    self.value = DeepClone(self:GetValue())
    return
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

    rawset(self, "_historyIndex", 1)
    rawset(self, "_historySize", #HttpService:JSONEncode(defaultValue))
    rawset(self, "_history", {{
        Size = if defaultValue then #HttpService:JSONEncode(defaultValue) else 0,
        Value = defaultValue
    }})

    rawset(self, "value", defaultValue)

    rawset(self, "_signal", signal.new())
    rawset(self, "_methods", {})

    return self
end

return module