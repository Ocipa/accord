<div align="center">⚠️Repo is in development, EVERYTHING is subject to change, until v1.0.0⚠️</div>
<br>

<p align="center" width="100%">
    <img src="./assets/logo.png">
</p>

## Example
```lua
local accord = require("path to accord")

local balance = accord:NewState(0) {
    Add = function(self, num: number)
        self.value += num
    end,

    Sub = function(self, num: number)
        self.value -= num
    end,
}

balance:Add(1)

-- by default, :Connect is defered, and in this
-- example, it will only print '3' one time
balance:Connect(function()
    print(balance:Get())
end)

balance:Add(1)
balance:Add(1)
```

## API

`Accord`
```lua
Accord:NewState<T>(defaultValue: T, config: Config?): <S>(methods: S | Methods<T>) -> State<T> & S
-- Creates a new state.
```

`State<T>`
```lua
State:Get(): T
-- Gets the value of the state.
```
```lua
State:Connect(callback: (): nil): Connection
-- Connects a callback to when the state value changes.
```
```lua
State:ConnectOnce(callback: (): nil): Connection
-- Connects a callback to when the state value changes once.
```
```lua
State:DisconnectAll(): nil
-- Disconnects all connections to the state.
```

## License

Distributed under the MIT License. See [LICENSE](./LICENSE) for more information.