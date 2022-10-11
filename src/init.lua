--!strict
local types = require(script.types)

local module = {}


function module.NewState<T>(defaultValue: T, config: types.Config?)
    return require(script.state)(defaultValue, config)
end

return module
