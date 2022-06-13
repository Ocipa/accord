# accord





## API

`Accord:newState(stateName: string, defaultValue: any): State`


---

`State:GetValue(): any?`

`State:Connect(callback: (value: any?, lastValue: any?)): signal.ScriptConnection`

`State:ConnectOnce(callback: (value: any?, lastValue: any?)): signal.ScriptConnection`





## Examples

```lua
local accord = require(path to accord)

accord:newState("TestState", 0)

function accord.TestState:TestMethod(number: number)
    self.value += number
end

accord.TestState:Connect(function(value, lastValue)
    print(("changed TestState from %s, to %s"):format(lastValue, value))
end)

accord.TestState:TestMethod(4)
-- prints "changed TestState from 0, to 4"

accord.TestState:TestMethod(7)
-- prints "changed TestState from 4, to 11"
```

```lua
-- script1
local accord = require(path to accord)

accord:newState("SomeState", "Hello")

function accord.SomeState:Concat(other: string)
    self.value = self.value .. other
end

accord.SomeState:ConnectOnce(function(value, lastValue)
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