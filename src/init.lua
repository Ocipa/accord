--!strict

local replicatedStorage = game:GetService("ReplicatedStorage")

local signal = require(script.Parent.fastsignal)

local types = require(script.types)

local module = {
    data = {},
    _signal = signal.new() :: types.Signal & any
} :: types.Accord
module.__index = module


--[[
    Creates a new state.

    ```lua
    accord:NewState("Balance", 0)
    ```
]]
---@param stateName string
---@param defaultValue any
---@param config Config | nil
---@return State
function module:NewState(stateName, defaultValue, config)
    module.data[stateName] = require(script.state)._new(stateName, defaultValue, config)

    return module.data[stateName]
end


--[[
    Gets the state.

    ```lua
    local balanceState = accord:GetState("Balance")
    ```
]]
---@param stateName string
---@return State
function module:GetState(stateName)
    return self.data[stateName]
end


--[[
    Connects a callback to when any state value changes.

    ```lua
    accord:Connect(function(stateName, value)
        print(("%s changed to %s"):format(stateName, value))
    end)
    ```
]]
---@param callback fun()
---@return ScriptConnection
function module:Connect(callback)
    return self._signal:Connect(callback)
end


--[[
    Connects a callback to when any state value changes once.

    ```lua
    accord:ConnectOnce(function(stateName, value)
        print(("%s changed to %s"):format(stateName, value))
    end)
    ```
]]
---@param callback fun()
---@return ScriptConnection
function module:ConnectOnce(callback)
    return self._signal:ConnectOnce(callback)
end


--[[
    Disconnects all connections to accord.

    ```lua
    accord:DisconnectAll()
    ```
]]
---@return nil
function module:DisconnectAll()
    self._signal:DisconnectAll()

    return nil
end


--[[
    Destroys a state, disconnecting the connections and removing the value.

    ```lua
    accord:DestroyState("Balance")
    ```
]]
---@param stateName string
---@return nil
function module:DestroyState(stateName)
    local state = self.data[stateName]

    if not state then
        return
    end

    self.data[stateName] = nil
    state = setmetatable(state, nil)

    if state._signal then
        state._signal:Destroy()
    end

    for i, _ in state._methods do
        state._methods[i] = nil
    end

    for i, _ in self do
        state[i] = nil
    end

    return nil
end


--[[
    Destroys all states, disconnecting the connections and removing the values.

    ```lua
    accord:DestroyAll()
    ```
]]
---@return nil
function module:DestroyAll()
    for i, _ in pairs(self.data) do
        self:DestroyState(i)
    end

    return nil
end

return setmetatable(module, {
    __index = function(self, key)
        return module.data[key]
    end
}) :: types.Accord & any
