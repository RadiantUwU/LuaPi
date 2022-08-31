local objinfo
local LuaPimt = {
	__metatable = false, --protected table
	__add = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__add__")(o)
	end,
	__sub = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__sub__")(o)
	end,
	__mul = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__mul__")(o)
	end,
	__div = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__div__")(o)
	end,
	__mod = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__mod__")(o)
	end,
	__pow = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__pow__")(o)
	end,
	__unm = function(t)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__unm__")()
	end,
	__concat = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__concat__")(o)
	end,
	__idiv = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__idiv__")(o)
	end,
	__band = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__band__")(o)
	end,
	__bor = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__bor__")(o)
	end,
	__bxor = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__bxor__")(o)
	end,
	__bnot = function(t)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__bnot__")()
	end,
	__lshift = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__shl__")(o)
	end,
	__rshift = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__shr__")(o)
	end,
	__tostring = function(t)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__str__")()
	end,
	__len = function(t)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__len__")()
	end,
	__tonumber = function(t)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__num__")()
	end,
	__toboolean = function(t)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__bool__")()
	end,
	__index = function(t,k)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__getitem__")(k)
	end,
	__newindex = function(t,k,v)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__setitem__")(k,v)
	end,
	__eq = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__eq__")(o)
	end,
	__lt = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__lt__")(o)
	end,
	__le = function(t,o)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return not (objinfo[object].contents.__getitem__(t,"__gt__")(o))
	end,
	__call = function(t,...)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__call__")(...)
	end,
	__gc = function(t)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__del__")()
	end,
	__pairs = function(t)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__iter__")()
	end,
	__next = function(t)
		local object = objinfo[objinfo[t].type].mro
		object = object[#object]
		return objinfo[object].contents.__getitem__(t,"__next__")()
	end,
}

local luaPimtarr = {}
for k,v in pairs(LuaPimt) do
	table.insert(luaPimtarr,v)
end