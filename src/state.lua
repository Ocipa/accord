--!strict

local HttpService = game:GetService("HttpService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local signal = require(script.Parent.Parent.fastsignal)

local types = require(script.Parent.types)

local module = {
    _value = nil
}

function module:AddMethod(methodName: string, callback: (...any) -> nil): nil
    rawset(self, methodName, function(...)
        rawset(self, "value", self._value)

        local success, result = pcall(function(...)
            callback(...)

            rawset(self, "_value", self.value)
            rawset(self, "value", nil)
        end, ...)

        if not success then
            warn(result)
        end
    end)

    return nil
end

function module:Get()
    return self._value
end

local metamodule = {}
metamodule.__index = module

metamodule.__newindex = function(...)
    print("---------:", ...)
end

local function _New<T, S>(defaultValue: T, methods, config: types.Config?)
    local self = setmetatable({}, metamodule) :: types.State<T> & S & any

    rawset(self, "_value", defaultValue)

    for methodName, method in methods do
        self:AddMethod(methodName, method)
    end

    return self
end

return function<T>(defaultValue: T, config: types.Config?)
    return function<S>(methods: S | types.Methods<T>): types.State<T> & S
        return _New(defaultValue, methods, config)
    end
end