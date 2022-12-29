function __luapi.newSandbox() 
    local public = ClassBuilder.public
    local protected = ClassBuilder.protected
    local private = ClassBuilder.private
    local metaclass = ClassBuilder.metaclass
    local extends = ClassBuilder.extends
    local final = ClassBuilder.final
    local static = ClassBuilder.static
    local field = ClassBuilder.field
    local object
    local metatype
    local class = ClassBuilder.class_func_custom(function(clsname,metacls,bases,isfinal,dict)
        metacls = metacls or metatype
        local k = rawisin(bases,object)
        if k then
            table.remove(bases,k)
        end
        table.insert(bases,object)
        local pubcontent = {}
        local protcontent = {}
        local privcontent = {}
        local fields = {}
        local vfields = {}
        for k,v in pairs(dict) do
            local classowns = not rawequal(v,field)
            if type(k) == "string" then
                fields[k] = newainfo("public",false,classowns)
                if classowns then
                    pubcontent[k] = v
                end
            elseif type(k) == "table" then
                fields[k.str] = newainfo(k.cls_builder__type,k.cls_builder__static == true,classowns)
                if classowns then
                    if k.cls_builder__type == "public" then
                        pubcontent[k.str] = v
                    elseif k.cls_builder__type == "protected" then
                        protcontent[k.str] = v
                    elseif k.cls_builder__type == "private" then
                        privcontent[k.str] = v
                    else
                        error("invalid key")
                    end
                end
            else
                error("invalid key")
            end
        end
        local cls = newtype(metacls,clsname,pubcontent,protcontent,privcontent,bases,fields,isfinal)
        getfenv(2)[clsname] = cls
        return cls
    end)
    object = class "object" {
        [protected "setFrozenState"]=function(self,val)
            objinfo[self].frozen = val
        end
        __str__=function(self)
            return "<LuaPi object of type \""..objinfo[objinfo[self].type].name.."\">"
        end
        __num__=invalidfunc("tonumber"),
        __add__=invalidfunc("add"),
        __sub__=invalidfunc("subtract"),
        __mul__=invalidfunc("multiply"),
        __div__=invalidfunc("division"),
        __mod__=invalidfunc("mod"),
        __pow__=invalidfunc("exponentiation"),
        __idiv__=invalidfunc("integer division"),
        __unm__=invalidfunc("unary negation"),
        __band__=invalidfunc("bitwise and"),
        __bor__=invalidfunc("bitwise or"),
        __bxor__=invalidfunc("bitwise xor"),
        __bnot__=invalidfunc("bitwise not"),
        __shl__=invalidfunc("shift left"),
        __shr__=invalidfunc("shift right"),
        __concat__=invalidfunc("concatenation"),
        __bool__=invalidfunc("toboolean"),
        __len__=invalidfunc("length of"),
        __getitem__=function(t,k)
            --check metamethod
            local rm = runningmeta
            runningmeta = false
            --get field info
            local field = objinfo[objinfo[t].type].fields[k]
            local v
            if field.accessor == "public" then
                --who owns it?
                if field.classowns then
                    v = classget(t,k,nil)
                else
                    v = objinfo[t].contents[k]
                end
                if type(v) == "function" and (not field.static) then
                    return addself(t,v)
                else
                    return v
                end
            elseif field.accessor == "protected" then
                -- do you have access to it?
                local auth_results = authf(objinfo[t].type,getfunc(({[false]=2,[true]=3})[rm]))
                assert(auth_results ~= nil,"security error")
                --who owns it?
                if field.classowns then
                    v = classget(t,k,true)
                else
                    v = objinfo[t].protectedcontent[k]
                end
                if type(v) == "function" and (not field.static) then
                    return addself(t,v)
                else
                    return v
                end
            elseif field.accessor == "private" then
                -- do you have access to it?
                local auth_results = authf(objinfo[t].type,getfunc(({[false]=2,[true]=3})[rm]))
                assert(auth_results ~= nil,"security error")
                --who owns it?
                if field.classowns then
                    v = classget(t,k,auth_results)
                else
                    v = objinfo[t].privatecontent[auth_results][k]
                end
                if type(v) == "function" and (not field.static) then
                    return addself(t,v)
                else
                    return v
                end
            end
        end
        __setitem__=function(t,k,v)
            --check metamethod
            local rm = runningmeta
            runningmeta = false
            --get field info
            local field = objinfo[objinfo[t].type].fields[k]
            local o = t
            local _o = objinfo[o]
            local ty = objinfo[t].type
            local _ty = objinfo[ty]
            if field.accessor == "public" then
                --who owns it?
                if field.classowns then
                    _ty.classcontent[k] = v
                else
                    _o.contents[k] = v
                end
            elseif field.accessor == "protected" then
                -- do you have access to it?
                local auth_results = authf(objinfo[t].type,getfunc(({[false]=2,[true]=3})[rm]))
                assert(auth_results ~= nil,"security error")
                --who owns it?
                if field.classowns then
                    _ty.protclscontent[k] = v
                else
                    _o.protectedcontent[k] = v
                end
                if type(v) == "function" and (not field.static) then
                    return addself(t,v)
                else
                    return v
                end
            elseif field.accessor == "private" then
                -- do you have access to it?
                local auth_results = authf(objinfo[t].type,getfunc(({[false]=2,[true]=3})[rm]))
                assert(auth_results ~= nil,"security error")
                --who owns it?
                if field.classowns then
                    _ty.privclscontent[k] = v
                else
                    _o.privatecontent[auth_results][k] = v
                end
                if type(v) == "function" and (not field.static) then
                    return addself(t,v)
                else
                    return v
                end
            end
        end,
        __lt__=invalidfunc("less than"),
        __gt__=invalidfunc("greater than"),
        __eq__=function(t,o)
            return rawequal(t,o)
        end,
        __call__=invalidfunc("call"),
        __new__=function(cls,...)
            return newobj(cls)
        end,
        __init__=function(o,...) end
        __del__=function(o,...) end
        __iter__=invalidfunc("iteration"),
        __next__=invalidfunc("next"),
        __pairs__=invalidfunc("pairs"),
        __ipairs__=invalidfunc("ipairs")
    }
    metatype = class "metatype" {
        __init__=invalidfunc("init"),
        __new__=invalidfunc("new"),
        __str__=function(o)
            return "<class \""..objinfo[o].name.."\">"
        end,
        __call__=function(cls,...)
            local o = cls.__new__(cls,...) 
            if isinstance(o,cls) then
                cls.__init__(o,...)
            end
            return o
        end
    }
    local _object = objinfo[object]
    local _metatype = objinfo[metatype]
    _object.type = metatype
    _metatype.type = metatype
    _object.frozen = true
    _metatype.frozen = true
    return {
        object=object,
        metatype=metatype,

        public=public,
        protected=protected,
        private=private,
        metaclass=metaclass,
        extends=extends,
        final=final,
        static=static,
        field=field,
        class=class,

        toboolean=function(o)
            if isObject(o) then
                return LuaPimt.__toboolean(o)
            elseif o then
                return true
            else
                return false
            end
        end,
        tonumber=function(o)
            if isObject(o) then
                return LuaPimt.__tonumber(o)
            else
                return tonumber(o)
            end
        end,
        tostring=function(o)
            if isObject(o) then
                return LuaPimt.__tostring(o)
            else
                return tostring(o)
            end
        end,
        ipairs=function(o)
            if isObject(o) then
                return LuaPimt.__ipairs(o)
            else
                return ipairs(o)
            end
        end,
        pairs=function(o)
            if isObject(o) then
                return LuaPimt.__pairs(o)
            else
                return pairs(o)
            end
        end,
        iter=function(o)
            if isObject(o) then
                return LuaPimt.__pairs(o)
            else
                error("not a luapi object")
            end
        end,
        next=function(o,...)
            if isObject(o) then
                return LuaPimt.__next(o,...)
            else
                return next(o,...)
            end
        end,
    }
end