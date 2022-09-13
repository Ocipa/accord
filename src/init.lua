--!strict
local state = require(script.state)
local types = require(script.types)

local module = {}




function module.NewState<T>(defaultValue: T, config: types.Config?)
    return require(script.state)(defaultValue, config)
end

-- function module:DestroyState(stateName)
--     local state = self.data[stateName]

--     if not state then
--         return
--     end

--     self.data[stateName] = nil
--     state = setmetatable(state, nil)

--     if state._signal then
--         state._signal:Destroy()
--     end

--     for i, _ in state._methods do
--         state._methods[i] = nil
--     end

--     for i, _ in self do
--         state[i] = nil
--     end

--     return nil
-- end

return module
