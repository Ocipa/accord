--!strict

local HttpService = game:GetService("HttpService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local signal = require(script.Parent.Parent.signal)

local types = require(script.Parent.types)
local util = require(script.Parent.util)

local module = {
    _signal = nil :: typeof(signal.new()),
    _changed = false,
}

function module:_Fire()
    self._signal:Fire()
    rawset(self, "_changed", false)
end

function module:_Changed()
    if self._changed then return end

    rawset(self, "_changed", true)

    if self.config["UPDATE_MODE"] == "Deferred" then
        task.defer(self._Fire, self)

    else
        self:_Fire()
    end
end

function module:Connect(callback: (...any) -> nil)
    self._signal:Connect(callback)
end

function module:AddMethod(methodName: string, callback: (...any) -> nil): nil
    rawset(self, methodName, function(...)
        rawset(self, "value", self._value)
        local changed = false

        local success, result = pcall(function(...)
            callback(...)

            changed = not util.isEqual(self.value, self._value)
            rawset(self, "_value", self.value)
        end, ...)

        rawset(self, "value", nil :: any)

        if not success then
            warn(result)

        elseif changed then
            self:_Changed()
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
    rawset(self, "_signal", signal.new())
    rawset(self, "config", require(script.Parent.config))

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