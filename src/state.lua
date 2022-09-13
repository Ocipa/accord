--!strict

local HttpService = game:GetService("HttpService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local signal = require(script.Parent.Parent.fastsignal)

local types = require(script.Parent.types)

local module = {
    value = 0
} :: types.State

-- local function isEqual(v1, v2)
--     if typeof(v1) ~= typeof(v2) then
--         return false
--     end

--     local t
--     t = {
--         table = function(val1, val2)
-- 			if typeof(val1) ~= typeof(val2) then
--                 return false
--             end

--             local bool = true
--             local indexs = {}

--             for i, v in val1 do
--                 indexs[i] = v
--             end

--             for i, v in val2 do
--                 indexs[i] = v
--             end

--             for i, v in indexs do
--                 bool = if t[typeof(v)] then t[typeof(v)](val1[i], val2[i]) else t["default"](val1[i], val2[i])

--                 if not bool then
--                     return false
--                 end
--             end

--             return bool
--         end,

--         default = function(val1, val2)
--             return val1 == val2
--         end
-- 	} :: {[string]: (...any) -> any}

--     return if t[typeof(v1)] then t[typeof(v1)](v1, v2) else t["default"](v1, v2)
-- end

-- local function DeepClone(val)
--     local t
--     t = {
-- 		table = function(val)
--             local new = {}

--             for i, v in val do
--                 new[i] = if t[typeof(v)] then t[typeof(v)](v) else t["default"](v)
--             end

--             return new
--         end,

-- 		default = function(val)
--             return val
--         end
-- 	} :: {[string]: (...any) -> any}

--     return if t[typeof(val)] then t[typeof(val)](val) else t["default"](val)
-- end

-- function module:__newindex(key, value)
--     if module[key] then
--         if typeof(module[key]) == "function" then
--             return rawget(self, key)(self, value)

--         else
--             rawset(self, key, value :: any)
--             return
--         end
--     end

--     rawset(rawget(self :: any, "_methods"), key, function(self: types.State, ...)
--         local success, errorMessage = pcall(value, self, ...)

--         if not success and not self._config["SILENCE_ERRORS"] then
--             task.spawn(function()
--                 error(errorMessage, 0)
--             end)
--         end

--         local CHECK_EQUAL = self._config.CHECK_IS_EQUAL_BEFORE_UPDATE
--         if success and (not CHECK_EQUAL or not isEqual(self.value, self._history[self._historyIndex].Value)) then
--             table.insert(self._history, self._historyIndex, {
--                 Size = if self.value then #HttpService:JSONEncode(self.value) else 0,
--                 Value = DeepClone(self.value)
--             } :: types.HistoryValue)

--             self._historySize += self._history[self._historyIndex].Size

--             for i=self._historyIndex - 1, 1, -1 do
--                 self._historySize -= self._history[i].Size
--                 table.remove(self._history, i)
--             end
--             self._historyIndex = 1

--             while #self._history > math.max(self._config.MAX_HISTORY_LENGTH :: number, 2) do
--                 self._historySize -= self._history[#self._history].Size
--                 table.remove(self._history, #self._history)
--             end

--             while self._historySize > self._config.MAX_HISTORY_SIZE :: number and #self._history > 2 do
--                 self._historySize -= self._history[#self._history].Size
--                 table.remove(self._history, #self._history)
--             end

-- 			self._signal:Fire(self:GetValue())
			
-- 			local accord = require(script.Parent) :: any
--             accord._signal:Fire(self._stateName, self:GetValue())
--         end
-- 	end)
	
-- 	return nil
-- end

-- function module:__index(key)
--     if rawget(self :: any, "_methods")[key] then
--         return rawget(self :: any, "_methods")[key]
--     end

--     return if typeof(module[key]) == "function" then module[key] else rawget(self, key)
-- end


-- --[[
--     Adds a method to the state.

--     ```lua
--     local addMethod = accord.Balance:AddMethod("Add", function(num: number)
--         self.value += num
--     end)

--     accord.Balance:Add(5) -- will not work in strict mode
--     addMethod(5) -- will work in strict mode
--     ```
-- ]]
-- ---@param methodName string
-- ---@param method function
-- ---@return function
-- function module:AddMethod(methodName, method)
--     rawset(rawget(self :: any, "_methods"), methodName, method)

--     return function(...)
--         method(self, ...)
--     end
-- end


-- --[[
--     Calls a method of a state.

--     ```lua
--     accord.Balance:AddMethod("Add", function(num: number)
--         self.value += num
--     end)

--     accord.Balance:CallMethod("Add", 5)
--     ```
-- ]]
-- ---@param methodName string
-- ---@return nil
-- function module:CallMethod(methodName, ...)
--     local method = rawget(rawget(self :: any, "_methods"), methodName)

--     method(self, ...)
-- end


-- --[[
--     Gets the value of the state.

--     ```lua
--     accord.Balance:GetValue()
--     ```
-- ]]
-- ---@return any
-- function module:GetValue()
--     return self._history[self._historyIndex].Value
-- end


-- --[[
--     Gets the last value of the state.

--     ```lua
--     accord.Balance:GetLastValue()
--     ```
-- ]]
-- ---@return any
-- function module:GetLastValue()
--     return self._history[math.clamp(self._historyIndex + 1, 1, #self._history)].Value
-- end


-- --[[
--     Rescinds the value of the state. If the num is negative, goes back in the\
--     value history, if num is positive, goes forward in value history, if nil,\
--     goes to the last history (the most recent value change).

--     ```lua
--     function accord.balance:Inc()
--         self.value += 2
--     end

--     accord.balance:Inc() -- balance = 2
--     accord.balance:Inc() -- balance = 4
--     accord.balance:Inc() -- balance = 6

--     accord.balance:RelativeRescind(-2) -- balance = 2
--     accord.balance:RelativeRescind() -- balance = 6
--     ```
-- ]]
-- ---@param num number | nil
-- function module:RelativeRescind(num)
--     assert(
--         typeof(num) == "number" or typeof(num) == "nil",
--         ("[ERROR]: state RelativeRescind: expected num to be of type number or nil, got %s"):format(typeof(num))
--     )

--     if num == 0 then return end

--     if not num then
--         self._historyIndex = 1

--     else
--         self._historyIndex = math.clamp(self._historyIndex - num, 1, #self._history)
--     end

--     self.value = DeepClone(self:GetValue())
--     return
-- end


-- --[[
--     Connects a callback to when the state value changes.

--     ```lua
--     accord.Balance:Connect(function(value)
--         print(("Balance changed to %s"):format(value))
--     end)
--     ```
-- ]]
-- ---@param callback fun()
-- ---@return Connection
-- function module:Connect(callback)
--     return self._signal:Connect(callback)
-- end


-- --[[
--     Connects a callback to when the state value changes once.

--     ```lua
--     accord.Balance:ConnectOnce(function(value)
--         print(("Balance changed to %s"):format(value))
--     end)
--     ```
-- ]]
-- ---@param callback fun()
-- ---@return Connection
-- function module:ConnectOnce(callback)
--     return self._signal:ConnectOnce(callback)
-- end


-- --[[
--     Disconnects all connections to the state.

--     ```lua
--     accord.Balance:DisconnectAll()
--     ```
-- ]]
-- ---@return nil
-- function module:DisconnectAll()
--     self._signal:DisconnectAll()

--     return nil
-- end


-- --[[
--     Destroys the state, disconnecting the connections and removing the value.

--     ```lua
--     accord.Balance:Destroy()
--     ```
-- ]]
-- ---@return nil
-- function module:Destroy()
--     -- NOTE: destroy the state from accord so that accord's index of this state
-- 	-- is also removed
-- 	local accord = require(script.Parent) :: any
--     accord:DestroyState(self._stateName)

--     return nil
-- end

-- function module._new(stateName, defaultValue, config): types.State
-- 	local self = {} :: types.State

--     rawset(self, "_stateName", stateName :: any)

--     local _config = config or {} :: types.Config

--     for i, v in pairs(require(script.Parent.config)) do
--         _config[i] = if _config[i] ~= nil then _config[i] else v
--     end
--     rawset(self, "_config", _config :: any)

--     rawset(self, "_historyIndex", 1 :: any)
--     rawset(self, "_historySize", (#HttpService:JSONEncode(defaultValue)) :: any)
--     rawset(self, "_history", {{
--         Size = if defaultValue then #HttpService:JSONEncode(defaultValue) else 0,
--         Value = defaultValue
--     }} :: any)

--     rawset(self, "value", defaultValue :: any)

--     rawset(self, "_signal", signal.new() :: any)
-- 	rawset(self, "_methods", {} :: any)

-- 	return setmetatable(self, module) :: any
-- end


type State<T> = {
    value: T
}
type Methods<T> = {
    [string]: (self: State<T>) -> nil
}

local module = {}

local function _new<T>(defaultValue: T, config)
    local self = setmetatable({}, {__index = module})


end

return function<T>(defaultValue: T, config: types.Config?): <A>(methods: A | Methods<T>) -> types.State<T> & A
    return function<A>(methods: A | Methods<T>): types.State<T> & A
        
    end
end