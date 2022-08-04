declare namespace Accord {
    interface Methods {
        NewState<T>(stateName: string, defaultValue: T, config?: Config): State<T>
        GetState(stateName: string): State<unknown>
        Connect(callback: (stateName: string, value: unknown) => void): Connection
        ConnectOnce(callback: (stateName: string, value: unknown) => void): Connection
        DisconnectAll(): void
        DestroyState(stateName: string): void
        DestroyAll(): void
    }
}

interface State<T> {
    value: T

    AddMethod(methodName: string, method: (state: State<T>) => void): (...T: unknown[]) => void
    CallMethod(methodName: string, ...T: unknown[]): void
    GetValue(): T
    GetLastValue(): T
    RelativeRescind(num: number): void
    Connect(callback: (value: T) => void): Connection
    ConnectOnce(callback: (value: T) => void): Connection
    DisconnectAll(): void
    Destroy(): void
}

type Config = {
    SILENCE_ERRORS?: boolean
    CHECK_IS_EQUAL_BEFORE_UPDATE?: boolean,
    MAX_HISTORY_LENGTH?: number
    MAX_HISTORY_SIZE?: number
}

type Connection = {
    Disconnect(): void
}

declare const Accord: Accord.Methods

export = Accord