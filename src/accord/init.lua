local replicatedStorage = game:GetService("ReplicatedStorage")

local signal = require(replicatedStorage.Packages.fastsignal)

local types = require(script.types)

local module = {
    data = {},
    _signal = signal.new()
} :: types.Accord
module.__index = module


function module:newState(stateName, defaultValue)
    module.data[stateName] = require(script.state)._new(stateName, defaultValue)
end

function module:Connect(callback)
    return self._signal:Connect(callback)
end

function module:ConnectOnce(callback)
    return self._signal:ConnectOnce(callback)
end

return setmetatable(module, {
    __index = function(self, key)
        return module.data[key]
    end
}) :: types.Accord
