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
    _lastValue: any?,
    value: any?,
    _signal: signal.Class,
    _methods: {[string]: (self: State, ...any) -> any},

    [string]: (self: State, ...any) -> any?,

    __index: (self: State, key: string) -> any?,
    __newindex: (self: State, key: string, value: any?) -> nil,
    GetValue: (self: State) -> any?,
    Connect: (self: State, callback: (value: any?, lastValue: any?) -> nil) -> signal.ScriptConnection,
    ConnectOnce: (self: State, callback: (value: any?, lastValue: any?) -> nil) -> nil,
    DisconnectAll: (self: State) -> nil,
    Destroy: (self: State) -> nil,
    _new: (stateName: string, defaultValue: any?) -> State
}


export type Config = {
    SILENCE_ERRORS: boolean,
    CHECK_IS_EQUAL_BEFORE_UPDATE: boolean,
    CLONE_VALUE_TO_LAST_VALUE: boolean
}


return nil