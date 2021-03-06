<h1 align="center">accord</h1>
<div align="center">⚠️Repo is in development, EVERYTHING is subject to change⚠️</div>
<br>

```lua
local accord = require(accord)

accord:NewState("balance", 0)

function accord.balance:Inc(num: number)
    self.value += num
end

function accord.balance:Dec(num: number)
    self.value -= num
end

print(accord.balance:GetValue()) -- 0

accord.balance:Inc(8)
print(accord.balance:GetValue()) -- 8

accord.balance:Dec(6)
print(accord.balance:GetValue()) -- 2
```

## API

`Accord`
```lua
Accord:NewState(stateName: string, defaultValue: any, config: Config?): State
-- Creates a new state.
```
```lua
Accord:GetState(stateName: string): State
-- Gets the state.
```
```lua
Accord:Connect(callback: (stateName: string, value: any?): nil): signal.ScriptConnection
-- Connects a callback to when any state value changes.
```
```lua
Accord:ConnectOnce(callback: (stateName: string, value: any?): nil): nil
-- Connects a callback to when any state value changes once.
```
```lua
Accord:DisconnectAll(): nil
-- Disconnects all connections to accord.
```
```lua
Accord:DestroyState(stateName: string): nil
-- Destroys a state, disconnecting the connections and removing the value.
```
```lua
Accord:DestroyAll(): nil
-- Destroys all states, disconnecting the connections and removing the values.
```

`State`
```lua
State:GetValue(): any?
-- Gets the value of the state.
```
```lua
State:GetLastValue(): any?
-- Gets the last value of the state.
```
```lua
State:RelativeRescind(num: number): nil
-- Rescinds the value of the state. If the num is negative, goes back in the
-- value history, if num is positive, goes forward in value history, if nil,
-- goes to the last history (the most recent value change).
```
```lua
State:Connect(callback: (value: any?): nil): signal.ScriptConnection
-- Connects a callback to when the state value changes.
```
```lua
State:ConnectOnce(callback: (value: any?): nil): nil
-- Connects a callback to when the state value changes once.
```
```lua
State:DisconnectAll(): nil
-- Disconnects all connections to the state.
```
```lua
State:Destroy(): nil
-- Destroys the state, disconnecting the connections and removing the value.
```





## Examples

```lua
local accord = require(path to accord)

accord:NewState("TestState", 0)

function accord.TestState:TestMethod(number: number)
    self.value += number
end

accord.TestState:Connect(function(value)
    print(("changed TestState from %s, to %s"):format(accord.TestState:GetLastValue(), value))
end)

accord.TestState:TestMethod(4)
-- prints "changed TestState from 0, to 4"

accord.TestState:TestMethod(7)
-- prints "changed TestState from 4, to 11"
```

```lua
-- script1
local accord = require(path to accord)

accord:NewState("SomeState", "Hello")

function accord.SomeState:Concat(other: string)
    self.value = self.value .. other
end

accord.SomeState:ConnectOnce(function(value)
    print(("%s"):format(value))
end)



-- script2
local accord = require(path to accord)

task.delay(1, function()
    accord.SomeState:Concat(" World!")
    -- prints "Hello World!"

    accord.SomeState:Concat(" Again!")
    -- does not print since ConnectOnce was used
end)
```

## License

Distributed under the MIT License. See [LICENSE](./LICENSE) for more information.