local force_public = {
	"__class__",
	"__mro__","__bases__","__fields__","__name__",
	"__add__","__sub__","__mul__","__div__","__mod__","__pow__","__unm__",
	"__concat__",
	"__bool__","__num__","__str__","__len__",
	"__getitem__","__setitem__",
	"__lt__","__eq__","__gt__",
	"__call__",
	"__new__","__init__",
	"__iter__","__next__"
}

local terminator

if _isLuau then
	terminator = function()
		local t = coroutine.running()
		if coroutine.isyieldable() then
			task.spawn(function()
				coroutine.close(t)
			end)
			coroutine.yield()
		else
			task.spawn(function()
				task.cancel(t)
			end)
			task.wait(16777216)
		end
	end
else
	terminator = function()
		local t = coroutine.running()
		coroutine.wrap(function()
			coroutine.resume(t)
			coroutine.close(t)
		end)()
		coroutine.yield()
		coroutine.yield()
	end
end

local callsecuritydestructor -- Kill and log security violations, regardless of what is happening
if _isLuau then
	local up = game
	function callsecuritydestructor(f:boolean) 
		if f then
			up.TestService:Error(debug.traceback(
				"Repeated attempts at indexing a function or field which is not authorized to do so.",
				3
				))
			terminator() -- Terminate thread.
		else
			up.TestService:Error(debug.traceback(
				"Attempted to index a function or field which is not authorized to do so.",
				4
				))
			error("Attempted to index a function or field which is not authorized to do so.",4)
		end
	end
else
	function callsecuritydestructor(f:boolean) 
		if f then
			warn(debug.traceback(
				"Repeated attempts at indexing a function or field which is not authorized to do so.",
				3
				))
			terminator() -- Terminate thread.
		else
			warn(debug.traceback(
				"Attempted to index a function or field which is not authorized to do so.",
				4
				))
			error("Attempted to index a function or field which is not authorized to do so.",4)
		end
	end
end

local accessorinfodefault = defaultreturnt({securityaccessor="public",static=false,classowns=false})
local objinfo = setmetatable({},{__metatable=false,__mode="k"}) -- hold object info across sandbox enviroments

local function isLuaPiObject(o)
	if objinfo[o] then
		return true
	end
	return false
end
local function isType(o)
	if not objinfo[o] then
		return false
	end
	if objinfo[o].mro then
		return true
	end
	return false
end
local function invalidfuncu(name)
	return function (t,...)
		error(name.." operation is not supported for object of type \""..objinfo[objinfo[t].type].__name__.."\"",2)
	end
end
local function invalidfuncb(name)
	return function(t, o,...)
		error(name.." operation is not supported for objects of type \""..objinfo[objinfo[t].type].__name__.."\" and \""..objinfo[objinfo[o].type].__name__.."\"",2)
	end
end
local function _table_find(t,v)
	for k,v2 in pairs(t) do
		if v2 == v then
			return k
		end
	end
	return nil
end
local function rawtable_find(t,v)
	for k,v2 in pairs(t) do
		if rawequal(v2,v) then
			return k
		end
	end
	return nil
end
local function base_table(...) 
	local t = {}
	for _,tv in ipairs(table.pack(...)) do
		for k,v in pairs(tv) do
			t[k] = v
		end
	end
	return t
end
local function reverse_table(t)
	local r = {}
	local l = #t
	for i = l,1,-1 do
		r[l-i+1] = t[i]
	end
	return r
end
local table_find = table.find or _table_find
local function ismetatablefunc(f)
	if table_find(luaPimtarr,f) then
		return true
	end
	return false
end
local getfunc

if _isLuau then
	function getfunc(level)
		return debug.info(level + 1,"f")
	end
else
	function getfunc(level)
		return debug.getinfo(level + 1,"f").func
	end
end
local function functionproxy(func)
	return function(...)
		return func(...)
	end
end
