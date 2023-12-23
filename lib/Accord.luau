local Signal = require(script.Parent.Signal)
local Symbol = require(script.Parent.Symbol)

-- TODO: figure out a better name for this.
type AccordMain<T> = {
	value: T,
	guard: (value: unknown) -> T,

	_signal: Signal.Signal<(T, T)>,
}

type AccordImpl<T> = {
	set: (self: Accord<T>, value: T | (value: T) -> T) -> (),
	get: (self: Accord<T>) -> T,
	forceUpdate: (self: Accord<T>) -> (),

	connect: (self: Accord<T>, fn: (value: T) -> ()) -> Signal.Connection<T>,
	once: (self: Accord<T>, fn: (value: T) -> ()) -> Signal.Connection<T>,
	disconnectAll: (self: Accord<T>) -> (),
}

export type Accord<T> = typeof(setmetatable({} :: AccordMain<T>, {} :: { __index: AccordImpl<T> }))

local module: AccordImpl<unknown> = {} :: AccordImpl<unknown>

function module:set(value)
	local oldValue = self.value

	local v = if typeof(value) == "function" then (value :: any)(oldValue) else value

	if v == Symbol.abort then
		return
	end

	self.value = if self.guard ~= Symbol.any then self.guard(v) else v

	self._signal:fire(self.value, oldValue)
end

function module:get()
	return self.value
end

function module:forceUpdate()
	self._signal:fire(self.value, self.value)
end

function module:connect(fn)
	return self._signal:connect(fn)
end

function module:once(fn)
	return self._signal:once(fn)
end

function module:disconnectAll()
	self._signal:disconnectAll()
end

local constructors = {
	new = function<T>(value: any, guard: ((value: unknown) -> T) | any): Accord<T>
		local self = {
			value = if typeof(guard) == "function" then (guard :: any)(value) else value,
			guard = guard,

			_signal = Signal.new(),
		}

		return setmetatable(self, { __index = module }) :: any
	end,

	is = function<T>(value: Accord<T>): boolean
		if typeof(value) ~= "table" then
			return false
		end

		return getmetatable(value) == module
	end,
}

return constructors
