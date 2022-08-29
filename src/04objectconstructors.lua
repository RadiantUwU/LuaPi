local privatefieldsmt = {
	__metatable = false,
	__index = function(t,k)
		local v = rawget(t,k)
		if v then
			return v
		else
			rawset(t,k,{})
			return rawget(t,k)
		end
	end
}
local function newObject()
	local o = setmetatable({},LuaPimt)
	addproxy(o)
	objinfo[o] = {
		contents = {},
		protectedcontent = {},
		privatecontent = setmetatable({},privatefieldsmt),
		--type = nil,
		frozen = false,
		authf = nil,
		unlockprivate = false,
		authorized = setmetatable({},{__metatable=false,__mode="kv"}), 
		notauthorized = setmetatable({},{__metatable=false,__mode="kv"})
	}
	return o
end
local function newObjectT(type)
	local o = newObject()
	objinfo[o].type = type
	return o
end
local function newType(env,name,metaclass,bases,final,dict)
	local o = newObjectT(metaclass or env.basetype)
	local field_ty = ClassBuilder.field
	local _o = objinfo[o]
	_o.contents.__name__ = name
	_o.bases = bases or {env.baseobject}
	_o.final = final
	_o.protectedfields = {}
	_o.privatefields = {}
	if not table.find(bases,env.baseobject) then
		table.insert(bases,env.baseobject)
	end
	_o.mro = {o}
	for _,base in ipairs(_o.bases) do
		if not isType(base) then
			error("One of the bases did not fulfill a condition: must be a type.")
		end
		for _,type in ipairs(objinfo[base].mro) do
			if objinfo[type].final then 
				error("Cannot extend final class \""..objinfo[type].contents.__name__.."\"") 
			end
			local f = table.find(_o.mro, type)
			if f then
				table.remove(_o.mro, f)
			end
			table.insert(_o.mro, type)
		end
	end
	_o.fields = setmetatable({},{__index=accessorinfodefault})
	local t = _o.contents
	local _t = _o.protectedfields
	local __t = _o.privatefields
	for k,v in pairs(dict) do
		local x
		if type(k) == "string" then
			x = {securityaccessor = "public",static=false,cls=weakref.new(o)}
			_o.fields[k.str] = x
			if v ~= field_ty then
				t[k.str] = v
				x.classowns = true
			else
				x.classowns = false
			end
		elseif type(k) == "table" then
			local isstatic = false
			x = {securityaccessor = k.cls_builder__type,static=isstatic,cls=weakref.new(o)}
			if k.cls_builder__static then isstatic = true end
			if k.cls_builder__type == "public" then
				_o.fields[k.str] = x
				if v ~= field_ty then
					t[k.str] = v
					x.classowns = true
				else
					x.classowns = false
				end
			elseif k.cls_builder__type == "protected" then
				_o.fields[k.str] = x
				if v ~= field_ty then
					_t[k.str] = v
					x.classowns = true
				else
					x.classowns = false
				end
			elseif k.cls_builder__type == "private" then
				_o.fields[k.str] = x
				if v ~= field_ty then
					__t[k.str] = v
					x.classowns = true
				else
					x.classowns = false
				end
			else
				error("Invalid key.")
			end
		else
			error("Invalid key.")
		end
	end
	_o.fields = (function(...) 
		local fieldst = reverse_table(table.pack(...))
		local fields = {}
		for _,cls in ipairs(fieldst) do 
			for k,v in pairs(objinfo[cls].fields) do
				fields[k] = v
			end
		end
		return fields
	end)(o,unpack(bases))
	return o
end