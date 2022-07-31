--!strict

---@class Accord
export type Accord = {
    [string]: State,
    data: {[string]: State},
    _signal: Signal,

    __index: Accord,
    NewState: (self: Accord, stateName: string, defaultValue: any, config: Config?) -> State,
    GetState: (self: Accord, stateName: string) -> State,
    Connect: (
        self: Accord,
        callback: (stateName: string, value: any?) -> nil
    ) -> Connection,
    ConnectOnce: (
        self: Accord,
        callback: (stateName: string, value: any?) -> nil
    ) -> Connection,
    DisconnectAll: (self: Accord) -> nil,
    DestroyState: (self: Accord, stateName: string) -> nil,
    DestroyAll: (self: Accord) -> nil
}


---@class State
export type State = {
    _stateName: string,
    _config: Config,

    _historyIndex: number,
    _historySize: number,
    _history: {[number]: HistoryValue},

    value: any?,
    _signal: Signal,
    _methods: {[string]: (self: State, ...any) -> any},

    [string]: (self: State, ...any) -> any?,

    __index: (self: State, key: string) -> any?,
	__newindex: (self: State, key: string, value: (...any) -> nil) -> nil,
    GetValue: (self: State) -> any?,
    GetLastValue: (self: State) -> any?,
    RelativeRescind: (self:State, num: number?) -> nil,
    Connect: (self: State, callback: (value: any?) -> nil) -> Connection,
    ConnectOnce: (self: State, callback: (value: any?) -> nil) -> Connection,
    DisconnectAll: (self: State) -> nil,
    Destroy: (self: State) -> nil,
    _new: (stateName: string, defaultValue: any?, config: Config?) -> State
}


---@class Config
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



---@class Signal
export type Signal = {
	Connect: (self: Signal, handler: (...any) -> ()) -> Connection,
	ConnectOnce: (self: Signal, handler: (...any) -> ()) -> Connection,
	Wait: (self: Signal) -> (...any),
	
	Fire: (self: Signal, ...any) -> nil,
	
	DisconnectAll: (self: Signal) -> nil,
	Destroy: (self: Signal) -> nil,
}

---@class Connection
export type Connection = {
	Disconnect: (self: Connection) -> nil
}


return nil