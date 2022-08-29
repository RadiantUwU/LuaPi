local dobaseobj
do
    local metaclass = ClassBuilder.metaclass
    local extends = ClassBuilder.extends
    local final = ClassBuilder.final
    local protected = ClassBuilder.protected
    local public = ClassBuilder.public
    local private = ClassBuilder.private
    local static = ClassBuilder.static
    local field = ClassBuilder.field

    function dobaseobj(class,env)
        env.object = class "object" {
            [protected "setFrozenState"] = function(self,state)
                objinfo[self].frozen = state
            end,
            [private "_securityCheck"] = function(self, func)
                local o = objinfo[self]
                local m = objinfo[o.type].mro
                for _,t in ipairs(m) do
                    local _t = objinfo[t]
                    for k,v in pairs(_t.contents) do
                        if type(v) == "function" then
                            if rawequal(v,func) then
                                if rawget(_t.fields,k) then
                                    return t
                                end
                            end
                        end
                    end
                    for k,v in pairs(_t.protectedcontent) do
                        if type(v) == "function" then
                            if rawequal(v,func) then
                                if rawget(_t.fields,k) then
                                    return t
                                end
                            end
                        end
                    end
                    for k,v in pairs(_t.privatecontent[t]) do
                        if type(v) == "function" then
                            if rawequal(v,func) then
                                if rawget(_t.fields,k) then
                                    return t
                                end
                            end
                        end
                    end
                end
            end,
            [protected "_getPublic"] = function(self)
                return objinfo[self].contents
            end,
            [protected "_getProtected"] = function(self)
                return objinfo[self].protectedcontent
            end,
            [protected "_getPrivate"] = function(self)
                local o = objinfo[self]
                o.authf = getfunc(2)
                local t = self.securityCheck("public",true)
                if t then
                    return o.privatecontent[t]
                end
            end,
            [private "getField"] = function(self,fieldname)
                local o = objinfo[objinfo[self].type]
                local f = o.fields[fieldname]
                if f then
                    local c = f.class:get()
                    return f.securityaccessor,c,objinfo[c]
                end
                return "public"
            end,
            [protected "setauthf"] = function (self,f)
                local o = objinfo[self]
                o.authf = f
            end,
            [protected "securityCheck"] = function(self,fieldname,b,i)
                i = i or 0
                local o = objinfo[self]
                if o.unlockprivate then
                    o.authf = nil -- patch security vulnerability
                    return true
                end
                local f = o.authf
                if not f then
                    f = getfunc(3 + i)
                    if ismetatablefunc(f) then
                        f = getfunc(4 + i)
                    end
                end
                o.authf = nil
                local object = objinfo[o.type].mro
                object = object[#object]
                local privateobject = objinfo[object].privatefields
                local field
                if b then
                    field = fieldname
                else
                    field = privateobject.getField(self,fieldname)
                end

                local a = o.authorized[f]
                if a ~= nil and (rawequal(field,"protected") or rawequal(field,a) or rawequal(field,"public")) then
                    return a
                elseif a then
                    callsecuritydestructor(false)
                elseif o.notauthorized[f] then
                    callsecuritydestructor(true)
                end
                a = privateobject._securityCheck(self,f)
                if a then
                    o.authorized[f] = a
                    return a
                else
                    o.notauthorized[f] = true
                    callsecuritydestructor(false)
                end
            end,
            [public "__add__"] = invalidfuncb("addition"),
            [public "__sub__"] = invalidfuncb("subtraction"),
            [public "__mul__"] = invalidfuncb("multiplication"),
            [public "__div__"] = invalidfuncb("division"),
            [public "__mod__"] = invalidfuncb("modulo"),
            [public "__pow__"] = invalidfuncb("power"),
            [public "__str__"] = function(t)
                return "<LuaO object of type \""..objinfo[objinfo[t].type].__name__.."\">"
            end,
            [public "__num__"] = invalidfuncu("tonumber"),
            [public "__bool__"] = function(t)
                return true
            end,
            [public "__len__"] = invalidfuncu("length"),
            [public "__eq__"] = function(t,o)
                return rawequal(t,o)
            end,
            [public "__lt__"] = invalidfuncb("less than"),
            [public "__gt__"] = invalidfuncb("greater than"),
            [public "__unm__"] =  invalidfuncu("unary minus"),
            [public "__call__"] = invalidfuncu("call"),
            [public "__getitem__"] = function (t,k)
                local x = objinfo[t]
                local acc = objinfo[x.type].fields[k]
                local co = acc.classowns
                if acc.securityaccessor ~= "public" then
                    local c = objinfo[object].contents.securityCheck(t,k)
                    if not co then
                        if acc.securityaccessor == "protected" then
                            return x.protectedcontent[k]
                        else
                            return x.privatecontent[c][k]
                        end
                    else
                        if acc.securityaccessor == "protected" then
                            local x = objinfo[x.type].protectedfields[k]
                            if type(x) == "function" and not acc.static then
                                return function(...)
                                    return x(t,...)
                                end
                            end
                            return x
                        else
                            local x = c.privatefields[k]
                            if type(x) == "function" and not acc.static then
                                return function(...)
                                    return x(t,...)
                                end
                            end
                            return x
                        end
                    end
                elseif co then
                    local x = objinfo[x.type].contents[k]
                    if type(x) == "function" and not acc.static then
                        return function(...)
                            return x(t,...)
                        end
                    end
                    return x
                else
                    return x.contents[k]
                end
            end,
            [public "__setitem__"] = function (t,k,v)
                local x = objinfo[t]
                local acc = objinfo[x.type].fields[k]
                local co = acc.classowns
                if acc.securityaccessor ~= "public" then
                    local c = objinfo[object].contents.securityCheck(t,k)
                    if not co then
                        if acc.securityaccessor == "protected" then
                            x.protectedcontent[k] = v
                        else
                            x.privatecontent[c][k] = v
                        end
                    else
                        if acc.securityaccessor == "protected" then
                            objinfo[x.type].protectedfields[k] = v
                        else
                            objinfo[c].privatefields[k] = v
                        end
                    end
                else
                    x.contents[k] = v
                end
            end,
            [public "__band__"] = invalidfuncb("bitwise and"),
            [public "__bor__"] = invalidfuncb("bitwise or"),
            [public "__bxor__"] = invalidfuncb("bitwise xor"),
            [public "__bnot__"] = invalidfuncu("bitwise not"),
            [public "__shl__"] = invalidfuncb("bitwise left shift"),
            [public "__shr__"] = invalidfuncb("bitwise right shift"),
            [public "__idiv__"] = invalidfuncb("integer division"),
            [public "__del__"] = function() end,
            [public "__new__"] = function(cls,...)
                return newObjectT(cls)
            end,
            [public "__init__"] = function(self,...) end
        }
    end
end
