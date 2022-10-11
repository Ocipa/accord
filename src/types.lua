--!strict

export type Accord = {
    NewState: <T>(defaultValue: T, config: Config?) -> State<T>,
}

export type State<T> = {
    value: T,
    config: Config,

    Connect: (self: State<T>, callback: () -> nil) -> Connection,
    ConnectOnce: (self: State<T>, callback: () -> nil) -> Connection,
    DisconnectAll: (self: State<T>) -> nil,
    Get: (self: State<T>) -> T,
}

export type Methods<T> = {
    [string]: (self: State<T>) -> nil
}

export type Config = {
    SILENCE_ERRORS: boolean?,
    CHECK_IS_EQUAL_BEFORE_UPDATE: boolean?,
    MAX_HISTORY_LENGTH: number?,
    MAX_HISTORY_SIZE: number?,
    UPDATE_MODE: "Deferred" | "Immediate",
}





export type Signal = {
	Connect: (self: Signal, handler: (...any) -> ()) -> Connection,
	ConnectOnce: (self: Signal, handler: (...any) -> ()) -> Connection,
	Wait: (self: Signal) -> (...any),

	Fire: (self: Signal, ...any) -> nil,

	DisconnectAll: (self: Signal) -> nil,
	Destroy: (self: Signal) -> nil,
}

export type Connection = {
	Disconnect: (self: Connection) -> nil
}


return nil