<p align="center"">
    <img src="./assets/logo.png" width="450" />
</p>
<div align="center">⚠️Library is in development, EVERYTHING is subject to change until v1.0.0⚠️</div>
<br>

## Example
```lua
-- basic example
local num = Accord.new(0, Guard.Number)

num:Connect(function(value, oldValue)
	print(`num changed from {oldValue} to {value}`)
end)
```

```lua
-- react hook example
return function<T>(value: Accord.Accord<T>): T
	local state, setState = React.useState(value:get())

	React.useEffect(function()
		local connection = value:connect(setState)

		return function()
			connection:disconnect()
		end
	end, { value })

	return state
end
```

## License

Distributed under the MIT License. See [LICENSE](./LICENSE) for more information.
