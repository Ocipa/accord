local replicatedStorage = game:GetService("ReplicatedStorage")

local signal = require(script.Parent.Parent.fastsignal)


export type Accord = {
    [string]: State,
    data: {[string]: State},
    _signal: signal.Class,

    __index: Accord,
    NewState: (self: Accord, stateName: string, defaultValue: any) -> State,
    GetState: (self: Accord, stateName: string) -> State,
    Connect: (
        self: Accord,
        callback: (stateName: string, value: any?, lastValue: any?) -> nil
    ) -> signal.ScriptConnection,
    ConnectOnce: (
        self: Accord,
        callback: (stateName: string, value: any?, lastValue: any?) -> nil
    ) -> nil,
    DisconnectAll: (self: Accord) -> nil,
    DestroyState: (self: Accord, stateName: string) -> nil,
    DestroyAll: (self: Accord) -> nil
}


export type State = {
    _stateName: string,

    _historyIndex: number,
    _historySize: number,
    _history: {[number]: HistoryValue},

    value: any?,
    _signal: signal.Class,
    _methods: {[string]: (self: State, ...any) -> any},

    [string]: (self: State, ...any) -> any?,

    __index: (self: State, key: string) -> any?,
    __newindex: (self: State, key: string, value: any?) -> nil,
    GetValue: (self: State) -> any?,
    GetLastValue: (self: State) -> any?,
    RelativeRescind: (self:State, num: number?) -> nil,
    Connect: (self: State, callback: (value: any?, lastValue: any?) -> nil) -> signal.ScriptConnection,
    ConnectOnce: (self: State, callback: (value: any?, lastValue: any?) -> nil) -> nil,
    DisconnectAll: (self: State) -> nil,
    Destroy: (self: State) -> nil,
    _new: (stateName: string, defaultValue: any?) -> State
}


export type Config = {
    SILENCE_ERRORS: boolean,
    CHECK_IS_EQUAL_BEFORE_UPDATE: boolean,
    MAX_HISTORY_LENGTH: number,
    MAX_HISTORY_SIZE:number
}

export type HistoryValue = {
    Size: number,
    Value: any?
}


return nil