local objinfo = setmetatable({},{__mode="k"})
local runningmeta = false
local classget -- (obj, field, scope(nil: public, true: protected, LuaPiType: private in)) -> field
local LuaPimt = {
	__metatable = false, --protected table 
	--notice, only __del__ is not public!
	__add = function(t,o)
		return classget(t,"__add__",nil)(t,o)
	end,
	__sub = function(t,o)
		return classget(t,"__sub__",nil)(t,o)
	end,
	__mul = function(t,o)
		return classget(t,"__mul__",nil)(t,o)
	end,
	__div = function(t,o)
		return classget(t,"__div__",nil)(t,o)
	end,
	__mod = function(t,o)
		return classget(t,"__mod__",nil)(t,o)
	end,
	__pow = function(t,o)
		return classget(t,"__pow__",nil)(t,o)
	end,
	__unm = function(t)
		return classget(t,"__unm__",nil)(t)
	end,
	__concat = function(t,o)
		return classget(t,"__concat__",nil)(t,o)
	end,
	__idiv = function(t,o)
		return classget(t,"__idiv__",nil)(t,o)
	end,
	__band = function(t,o)
		return classget(t,"__band__",nil)(t,o)
	end,
	__bor = function(t,o)
		return classget(t,"__bor__",nil)(t,o)
	end,
	__bxor = function(t,o)
		return classget(t,"__bxor__",nil)(t,o)
	end,
	__bnot = function(t)
		return classget(t,"__bnot__",nil)(t)
	end,
	__lshift = function(t,o)
		return classget(t,"__lshift__",nil)(t,o)
	end,
	__rshift = function(t,o)
		return classget(t,"__rshift__",nil)(t,o)
	end,
	__tostring = function(t)
		return classget(t,"__str__",nil)(t)
	end,
	__len = function(t)
		return classget(t,"__len__",nil)(t)
	end,
	__tonumber = function(t)
		return classget(t,"__num__",nil)(t)
	end,
	__toboolean = function(t)
		return classget(t,"__bool__",nil)(t)
	end,
	__index = function(t,k)
		runningmeta = 3
		return classget(t,"__getitem__",nil)(t,k)
	end,
	__newindex = function(t,k,v)
		runningmeta = 3
		if objinfo[t].frozen then
			error("object is frozen",2)
		end
		return classget(t,"__setitem__",nil)(t,k,v)
	end,
	__eq = function(t,o)
		return classget(t,"__eq__",nil)(t,o)
	end,
	__lt = function(t,o)
		return classget(t,"__lt__",nil)(t,o)
	end,
	__le = function(t,o)
		return not classget(t,"__gt__",nil)(t,o)
	end,
	__call = function(t,...)
		return classget(t,"__call__",nil)(t,...)
	end,
	__gc = function(t)
		return classget(t,"__del__",true)(t)
	end,
	__pairs = function(t)
		return classget(t,"__pairs__",nil)(t)
	end,
	__iter = function(t)
		return classget(t,"__iter__",nil)(t)
	end,
	__ipairs = function(t)
		return classget(t,"__ipairs__",nil)(t)
	end,
	__next = function(t,...)
		return classget(t,"__next__",nil)(t,...)
	end,
}