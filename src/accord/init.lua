local replicatedStorage = game:GetService("ReplicatedStorage")

local signal = require(replicatedStorage.Packages.fastsignal)

local types = require(script.types)

local module = {
    data = {},
    _signal = signal.new()
} :: types.Accord
module.__index = module


function module:NewState(stateName, defaultValue)
    module.data[stateName] = require(script.state)._new(stateName, defaultValue)

    return module.data[stateName]
end

function module:GetState(stateName)
    return self.data[stateName]
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

return setmetatable(module, {
    __index = function(self, key)
        return module.data[key]
    end
}) :: types.Accord
