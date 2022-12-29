local function isObject(o)
    return not rawequal(objinfo[o],nil)
end
local function isType(o)
    return isObject(o) and (not rawequal(objinfo[o].final,nil))
end
local function _authf(type, func)
    for _,ty in ipairs(objinfo[type].mro) do 
        for _,f in pairs(ty.classcontent) do
            if rawequal(f,func) then return ty end
        end
        for _,f in pairs(ty.protclscontent) do
            if rawequal(f,func) then return ty end
        end
        for _,f in pairs(ty.privclscontent) do
            if rawequal(f,func) then return ty end
        end
    end
    return false
end
local function authf(type, func)
    for f,t in ipairs(objinfo[type].authorized) do 
        if rawequal(f,func) then return t end
    end
    for f,t in ipairs(objinfo[type].notauthorized) do 
        if rawequal(f,func) then return false end
    end
    local r = _authf(type, func)
    if r then
        objinfo[type].authorized = r;
    else
        objinfo[type].notauthorized = r;
    end
    return r
end
local function newobj(typ)
    local t = setmetatable({},LuaPimt)
    objinfo[t] = {
        contents={},
        protectedcontent={},
        privatecontent=setmetatable({},__index=function(t,k)
            local i = {}
            t[k] = i
            return i
        end),
        type=typ,
        frozen=false
    }
    return t
end
local function basetable(...)
    local t = {}
    for _,tt in ipairs(table.pack(...)) do
        for k,v in pairs(tt) do
            t[k] = v
        end
    end
    return t
end
local function rawisin(t,v)
    for k,vv in pairs(t) do 
        if rawequal(v,vv) then return k end
    end
    return false
end
local fieldsmt = {
    __index=function(t,k)
        return {securityaccessor="public",static=true,classowns=false}
    end
}
local function newainfo(securityaccessor,classowns,static)
    return {
        securityaccessor=securityaccessor or "public",
        classowns=classowns,
        static=static or (not classowns)
    }
end
local function invalidfunc(opname)
    return function(self)
        error("operation "..opname.." cannot be used on object of type \""..objinfo[objinfo[self].type].name.."\"",2)
    end
end
local function addself(self,func)
    local function __internalLuaPiMethodType(...)
        return func(self,...)
    end
    return __internalLuaPiMethodType
end
local function newtype(typ,name,pubcontent,protcontent,privcontent,bases,fields,final)
    local o = newobj(typ)
    _o = basetable(objinfo[o], {
        bases=bases,
        final=final,
        fields=setmetatable(fields,fieldsmt),
        classcontent=pubcontent,
        protclscontent=protcontent,
        privclscontent=privcontent,
        authorized={},
        notauthorized={},
        name=name,
        mro={[1]=o}
    })
    local mro = _o.mro
    for _,bases in ipairs(bases) do
        local _b = objinfo[bases]
        for _,t in ipairs(_b.mro) do
            local l = rawisin(mro,t)
            if rawequal(l,nil) then
                table.remove(mro,k)
            end
            table.insert(mro,v)
        end
    end
    local nf = {}
    for _,t in ipairs(bases) do
        table.insert(nf,objinfo[t].fields)
    end
    nf = basetable(table.unpack(nf),fields)
    _o.fields = nf
    return o
end
local function classget(obj,field,scope)
    local typ = objinfo[obj].type
    local mro = objinfo[typ].mro
    if rawequal(scope,nil) then --public
        for _,t in ipairs(mro) do
            local _t = objinfo[t]
            local v = _t.classcontent[field]
            if !rawequal(v,nil) then
                return v
            end
        end
    elseif rawequal(scope,true) then--protected
        for _,t in ipairs(mro) do
            local _t = objinfo[t]
            local v = _t.protclscontent[field]
            if !rawequal(v,nil) then
                return v
            end
        end
    else
        assert(rawisin(mro,scope))
        return objinfo[scope].privclscontent[field]
    end
end
local function isinstance(obj,cls)
    local mro = objinfo[objinfo[o].type].mro
    if rawisin(mro,cls) then
        return true
    end
    return false
end
local function tableextend(src,dst)
    for k,v in pairs(src) do
        dst[k] = v
    end
    return dst
end