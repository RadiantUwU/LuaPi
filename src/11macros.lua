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
local function newobj()
    local t = setmetatable({},LuaPimt)
    objinfo[t] = {
        contents={},
        protectedcontent={},
        privatecontent={},
        type=nil,
        frozen=false
    }
    return t
end
local function newtype()
    local t = setmetatable({}, LuaPimt)
end