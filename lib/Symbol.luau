local abortSymbol = newproxy(true)
getmetatable(abortSymbol).__tostring = function()
	return "Symbol<abort>"
end

return {
	abort = abortSymbol,
}
