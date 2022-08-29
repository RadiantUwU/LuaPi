local LuaPimt = {
	__metatable = false, --protected table
	__add = function(t,o)
		return objinfo[t].type.__add__(t,o)
	end,
	__sub = function(t,o)
		return objinfo[t].type.__sub__(t,o)
	end,
	__mul = function(t,o)
		return objinfo[t].type.__mul__(t,o)
	end,
	__div = function(t,o)
		return objinfo[t].type.__div__(t,o)
	end,
	__mod = function(t,o)
		return objinfo[t].type.__mod__(t,o)
	end,
	__pow = function(t,o)
		return objinfo[t].type.__pow__(t,o)
	end,
	__unm = function(t)
		return objinfo[t].type.__unm__(t)
	end,
	__concat = function(t,o)
		return objinfo[t].type.__concat__(t,o)
	end,
	__tostring = function(t)
		return objinfo[t].type.__str__(t)
	end,
	__len = function(t)
		return objinfo[t].type.__len__(t)
	end,
	__call = function(t,...)
		return objinfo[t].type.__call__(t,...)
	end,
	__eq = function(t,o)
		return objinfo[t].type.__eq__(t,o)
	end,
	__le = function	(t,o)
		return not (objinfo[t].type.__gt__(t,o))
	end,
	__lt = function(t,o)
		return objinfo[t].type.__lt__(t,o)
	end,
	__index = function(t,k)
		return objinfo[t].type.__getitem__(t,k)
	end,
	__newindex = function(t,k,v)
		return objinfo[t].type.__setitem__(t,k,v)
	end,

	__band = function(t,o)
		return objinfo[t].type.__band__(t,o)
	end,
	__bor = function(t,o)
		return objinfo[t].type.__bor__(t,o)
	end,
	__bxor = function(t,o)
		return objinfo[t].type.__bxor__(t,o)
	end,
	__bnot = function(t)
		return objinfo[t].type.__bnot__(t)
	end,
	__shl = function(t,o)
		return objinfo[t].type.__shl__(t,o)
	end,
	__shr = function(t,o)
		return objinfo[t].type.__shr__(t,o)
	end,
	__idiv = function(t,o)
		return objinfo[t].type.__idiv__(t,o)
	end,
	__gc = function(t)
		return objinfo[t].type.__del__(t)
	end,
}

local luaPimtarr = {}
for k,v in pairs(LuaPimt) do
	table.insert(luaPimtarr,v)
end