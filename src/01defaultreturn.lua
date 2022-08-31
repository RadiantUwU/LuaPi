local function defaultreturn(v)
	return function(...)
		return v
	end
end
local function defaultreturnt(t)
	return function(...)
		local r = {}
		for k,v in pairs(t) do
		r[k] = v
		end
		return r
	end
end