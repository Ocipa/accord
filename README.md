<h1 align="center">accord</h1>
<div align="center">⚠️Repo is in development, EVERYTHING is subject to change⚠️</div>

<br>
<div style="-webkit-column-count: 2; -moz-column-count: 2; column-count: 2;">
<div align="center"><h3>accord</h3></div>
<pre><code class="lang-lua"><span class="hljs-keyword">local</span> accord = <span class="hljs-built_in">require</span>(accord)
<nl>
accord:NewState(<span class="hljs-string">"balance"</span>, <span class="hljs-number">0</span>)
<nl>
<span class="hljs-function"><span class="hljs-keyword">function</span> <span class="hljs-title">accord.balance:Inc</span><span class="hljs-params">()</span></span>
    self.value += <span class="hljs-number">1</span>
<span class="hljs-keyword">end</span>
<nl>
<span class="hljs-function"><span class="hljs-keyword">function</span> <span class="hljs-title">accord.balance:Dec</span><span class="hljs-params">()</span></span>
    self.value -= <span class="hljs-number">1</span>
<span class="hljs-keyword">end</span>
<nl>
accord.balance:GetValue() <span class="hljs-comment">-- 0</span>
<nl>
accord.balance:Inc()
accord.balance:GetValue() <span class="hljs-comment">-- 1</span>
<nl>
accord.balance:Dec()
accord.balance:GetValue() <span class="hljs-comment">-- 0</span>
<nl>
<nl>
<nl>
<nl>
<nl>
<nl>
<nl>
<nl>
<nl>
<nl>
</code></pre>
<div align="center"><h3>rodux</h3></div>
<pre><code class="lang-lua">local rodux = rquire(rodux)
<nl>
local function reducer(<span class="hljs-keyword">state</span>, action)
    <span class="hljs-keyword">state</span> = <span class="hljs-keyword">state</span> or {
        balance = <span class="hljs-number">0</span>
    }
    <nl>
    if action.type == <span class="hljs-string">"inc"</span> then
        return {balance = <span class="hljs-keyword">state</span>.balance + <span class="hljs-number">1</span>}
    <nl>
    elseif action.type == <span class="hljs-string">"dec"</span> then
        return {balance = <span class="hljs-keyword">state</span>.balance - <span class="hljs-number">1</span>}
    end
    <nl>
    return <span class="hljs-keyword">state</span>
end
<nl>
local store = rodux.Store.new(reducer)
store:getState() -- {balance = <span class="hljs-number">0</span>}
<nl>
store:dispatch({
    type = <span class="hljs-string">"inc"</span>
})
store:getState() -- {balance = <span class="hljs-number">1</span>}
<nl>
store:dispatch({
    type = <span class="hljs-string">"dec"</span>
})
store:getState() -- {balance = <span class="hljs-number">0</span>}
</code></pre>
</div>



## API

`Accord`
```lua
Accord:NewState(stateName: string, defaultValue: any): State
-- Creates a new state.
```
```lua
Accord:GetState(stateName: string): State
-- Gets the state.
```
```lua
Accord:Connect(callback: (stateName: string, value: any?, lastValue: any?): nil): signal.ScriptConnection
-- Connects a callback to when any state value changes.
```
```lua
Accord:ConnectOnce(callback: (stateName: string, value: any?, lastValue: any?): nil): nil
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
State:Connect(callback: (value: any?, lastValue: any?): nil): signal.ScriptConnection
-- Connects a callback to when the state value changes.
```
```lua
State:ConnectOnce(callback: (value: any?, lastValue: any?): nil): nil
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

accord:NewState("SomeState", "Hello")

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

## License

Distributed under the MIT License. See [LICENSE](./LICENSE) for more information.