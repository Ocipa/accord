local module = {}

function module.deepCopy<T>(a: T): T
	local copy = a

	if typeof(a) == "table" then
		local clone: any = table.clone(a)

		for i, v in pairs(clone) do
			clone[i] = module.deepCopy(v)
		end

		copy = clone
	end

	return copy
end

function module.deepEqual(a: any, b: any): boolean
	if typeof(a) ~= "table" or typeof(b) ~= "table" then
		return a == b
	end

	local key1, value1 = next(a)
	local key2, value2 = next(b)

	while key1 and key2 do
		if b[key1] ~= value1 or a[key2] ~= value2 then
			return false
		end

		key1, value1 = next(a, key1)
		key2, value2 = next(b, key2)
	end

	return true
end

return module
