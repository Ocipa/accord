local types = require(script.types)

local module = {
    data = {}
} :: types.Accord
module.__index = module


function module:newState(stateName, defaultValue)
    module.data[stateName] = require(script.state)._new(stateName, defaultValue)
end


return setmetatable(module, {
    __index = function(self, key)
        return module.data[key]
    end
}) :: types.Accord
