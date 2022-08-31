local dobasetype
do
    local metaclass = ClassBuilder.metaclass
    local extends = ClassBuilder.extends
    local final = ClassBuilder.final
    local protected = ClassBuilder.protected
    local public = ClassBuilder.public
    local private = ClassBuilder.private
    local static = ClassBuilder.static
    local field = ClassBuilder.field

    function dobasetype(class,env)
        env.basetype = class "class" {
            ["__add__"] = function(self,t)
                local _o = objinfo[self].contents
                local _t = objinfo[t].contents
                assert(isType(t))
                assert(isType(self))
                return class (_o.__name__.._t.__name__) (extends(self,t)) {}
            end,
            ["__new__"] = function(cls,...)
                local t = table.pack(...)
                assert(#t > 3, "too less arguments")
                return newType(env,t[1],cls,t[2],t[3],t[4])
            end,
            ["__call__"] = function(self,...)
                local fields = objinfo[self].fields
                local o = objinfo[fields["__new__"].cls:get()].contents.__new__(self,...)
                local m = objinfo[self].mro
                if rawtable_find(m,objinfo[o].type) then
                    local x = objinfo[fields["__init__"].cls:get()].contents.__init__(o,...)
                    if x ~= nil then
                        return o
                    end
                end
                return o
            end,
            [private "getField"] = function(self,fieldname)
                local o = objinfo[objinfo[self].type]
                local f = o.fields[fieldname]
                if f then
                    local c = f.class:get()
                    return f.securityaccessor,c,objinfo[c]
                end
            end,
            [private "_securityCheck"] = function(self, func)
                local o = objinfo[self]
                local m = objinfo[o].mro
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
                local m = o.mro
                local basetype = objinfo[o.type].mro
                basetype = basetype[#basetype - 1]
                local privatebasetype = objinfo[basetype].privatefields
                local field
                if b then
                    field = fieldname
                else
                    field = privatebasetype.getField(self,fieldname)
                end

                local a = o.authorized[f]
                if a ~= nil and (rawequal(field,"protected") or rawequal(field,a) or rawequal(field,"public")) then
                    return a
                elseif a then
                    callsecuritydestructor(false)
                elseif o.notauthorized[f] then
                    callsecuritydestructor(true)
                end
                a = privatebasetype._securityCheck(self,f)
                if a then
                    o.authorized[f] = a
                    return a
                else
                    o.notauthorized[f] = true
                    callsecuritydestructor(false)
                end
            end,
            ["__getitem__"] = function(self,k)
                local o = objinfo[self]
                local m = o.mro
                local t_m = objinfo[o.type].mro
                local basetype = t_m[#t_m - 1]
                local privatebasetype = objinfo[basetype].privatefields
                local field,class,_class = privatebasetype.getField(self,k)
                if field then
                    if field == "public" then
                        return _class.contents[k]
                    else
                        local c = objinfo[basetype].protectedfields.securityCheck(self,k)
                        if field == "protected" then
                            return _class.protectedcontent[k]
                        else
                            return _class.privatecontent[c][k]
                        end
                    end
                else
                    return objinfo[self].contents[k]
                end
            end,
            ["__str__"] = function(self)
                return "<class \""..tostring(objinfo[self].contents.__name__).."\">"
            end
        }
    end
end