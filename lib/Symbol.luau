local abortSymbol = newproxy(true)
getmetatable(abortSymbol).__tostring = function()
	return "Symbol<abort>"
end

local anySymbol = newproxy(true)
getmetatable(anySymbol).__tostring = function()
	return "Symbol<any>"
end

return {
	abort = abortSymbol,
	any = anySymbol,
}
