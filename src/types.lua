--!strict

-- export type State = {
--     _stateName: string,
--     _config: Config,

--     _historyIndex: number,
--     _historySize: number,
--     _history: {[number]: HistoryValue},

--     value: any?,
--     _signal: Signal,
--     _methods: {[string]: (self: State, ...any) -> any},

--     [string]: (self: State, ...any) -> any?,

--     __index: (self: State, key: string) -> any?,
-- 	__newindex: (self: State, key: string, value: (...any) -> nil) -> nil,
--     AddMethod: (self: State, methodName: string, method: (state: State, ...any) -> nil) -> (...any) -> nil,
--     CallMethod: (self: State, methodName: string, ...any) -> nil,
--     GetValue: (self: State) -> any?,
--     GetLastValue: (self: State) -> any?,
--     RelativeRescind: (self:State, num: number?) -> nil,
--     Connect: (self: State, callback: (value: any?) -> nil) -> Connection,
--     ConnectOnce: (self: State, callback: (value: any?) -> nil) -> Connection,
--     DisconnectAll: (self: State) -> nil,
--     Destroy: (self: State) -> nil,
--     _new: (stateName: string, defaultValue: any?, config: Config?) -> State
-- }

export type Accord = {
    NewState: <T>(defaultValue: T, config: Config?) -> State<T>,
}

export type State<T> = {
    value: T
}

export type Config = {
    SILENCE_ERRORS: boolean?,
    CHECK_IS_EQUAL_BEFORE_UPDATE: boolean?,
    MAX_HISTORY_LENGTH: number?,
    MAX_HISTORY_SIZE: number?
}

export type HistoryValue = {
    Size: number,
    Value: any?
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