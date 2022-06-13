local replicatedStorage = game:GetService("ReplicatedStorage")

local signal = require(replicatedStorage.Packages.fastsignal)


export type Accord = {
    [string]: State,
    data: {[string]: State},
    _signal: signal.Class,

    __index: Accord,
    NewState: (self: Accord, stateName: string, defaultValue: any) -> any,
    Connect: (
        self: Accord,
        callback: (stateName: string, value: any?, lastValue: any?) -> nil
    ) -> signal.ScriptConnection,
    ConnectOnce: (
        self: Accord,
        callback: (stateName: string, value: any?, lastValue: any?) -> nil
    ) -> nil
}


export type State = {
    _stateName: string,
    _lastValue: any?,
    value: any?,
    _signal: signal.Class,
    _methods: {[string]: (self: State, ...any) -> any},
    _connections: {[number]: signal.ScriptConnection},

    [string]: (self: State, ...any) -> any,

    __index: (self: State, key: string) -> any?,
    __newindex: (self: State, key: string, value: any?) -> nil,
    GetValue: (self: State) -> any?,
    Connect: (self: State, callback: (value: any?, lastValue: any?) -> nil) -> signal.ScriptConnection,
    ConnectOnce: (self: State, callback: (value: any?, lastValue: any?) -> nil) -> nil,
    _new: (stateName: string, defaultValue: any?) -> State
}


export type Config = {
    SILENCE_ERRORS: boolean
}


return nil