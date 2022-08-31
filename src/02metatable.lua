local objinfo
local LuaPimt = {
	__metatable = false, --protected table
	__add = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__add__")(t,o)
	end,
	__sub = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__sub__")(t,o)
	end,
	__mul = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__mul__")(t,o)
	end,
	__div = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__div__")(t,o)
	end,
	__mod = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__mod__")(t,o)
	end,
	__pow = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__pow__")(t,o)
	end,
	__unm = function(t)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__unm__")(t)
	end,
	__concat = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__concat__")(t,o)
	end,
	__idiv = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__idiv__")(t,o)
	end,
	__band = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__band__")(t,o)
	end,
	__bor = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__bor__")(t,o)
	end,
	__bxor = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__bxor__")(t,o)
	end,
	__bnot = function(t)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__bnot__")(t)
	end,
	__lshift = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__shl__")(t,o)
	end,
	__rshift = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__shr__")(t,o)
	end,
	__tostring = function(t)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__str__")(t)
	end,
	__len = function(t)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__len__")(t)
	end,
	__tonumber = function(t)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__num__")(t)
	end,
	__toboolean = function(t)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__bool__")(t)
	end,
	__index = function(t,k)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__getitem__")(t,k)
	end,
	__newindex = function(t,k,v)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__setitem__")(t,k,v)
	end,
	__eq = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__eq__")(t,o)
	end,
	__lt = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__lt__")(t,o)
	end,
	__le = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return not (objinfo[object].contents.__getitem__(t,"__gt__")(t,o))
	end,
	__call = function(t,...)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__call__")(t,...)
	end,
	__gc = function(t)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__gc__")(t)
	end,
	__pairs = function(t)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__iter__")(t)
	end,
	__next = function(t)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__next__")(t)
	end,
}

local luaPimtarr = {}
for k,v in pairs(LuaPimt) do
	table.insert(luaPimtarr,v)
end