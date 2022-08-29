local function defaultreturn(v)
	return function(...)
		return v
	end
end
local function defaultreturnt(t)
	return function(...)
		return table.clone(t)
	end
end