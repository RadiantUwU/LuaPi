local function tryfunc(func,...)
	local p = table.pack(...)
	local x = table.pack(pcall(function()
		return func(table.unpack(p))
	end))
	return table.unpack(x)
end
local function tryexcept(try:(any...)->any...,except:(string)->any...,...: any...): any...
	local p = table.pack(tryfunc(try,...))
	if not p[1] then
		return except(p[2])
	end
	table.remove(p,1)
	return table.unpack(p)
end
local function tryfinally(try:(any...)->any...,finally:(any...)->nil,...: any...): any...
	local p = table.pack(tryfunc(try,...))
	finally(...)
	if not p[1] then
		error(p[2])
	end
	table.remove(p,1)
	return table.unpack(p)
end
local function tryexceptfinally(try:(any...)->any...,except:(string)->any...,finally:(any...)->any...,...: any...): any...
	local p = table.pack(tryfunc(tryexcept,try,except,...))
	finally(...)
	if not p[1] then
		error(p[2])
	end
	table.remove(p,1)
	return table.unpack(p)
end