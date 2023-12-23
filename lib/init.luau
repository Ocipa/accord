local Accord = require(script.Accord)
local Signal = require(script.Signal)
local Symbol = require(script.Symbol)

export type Accord<T> = Accord.Accord<T>

export type Signal<T...> = Signal.Signal<T...>
export type Connection<T...> = Signal.Connection<T...>

return {
	new = Accord.new,
	is = Accord.is,

	abort = Symbol.abort,
}
