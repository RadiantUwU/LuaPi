local _rawget = rawget
local _rawset = rawset
local _rawlen = rawlen
__luapi.new = function() 
    local env = {}
    local basetype
    local class = ClassBuilder.class_func_custom(function(cls_name,metaclass,processed_bases,isfinal,newdict)
        metaclass = metaclass or basetype
        return metaclass.__new__(cls_name,metaclass,processed_bases,isfinal,newdict)
    end)
    initenv(class,env)
    basetype = env.basetype
    env = base_table(_G or {},_ENV or {},env,{
        metaclass = ClassBuilder.metaclass,
        extends = ClassBuilder.extends,
        final = ClassBuilder.final,
        protected = ClassBuilder.protected,
        public = ClassBuilder.public,
        private = ClassBuilder.private,
        static = ClassBuilder.static,
        field = ClassBuilder.field,
        class = class,
        isinstance = function(o,t)
            return rawtable_find(objinfo[objinfo[o].type].mro,t)
        end,
        issubclass = function(c,t)
            assert(isType(c),"must be a type")
            assert(isType(t),"must be a type")
            return rawtable_find(objinfo[c].mro,t)
        end,
        isType = functionproxy(isType),
        isLuaPiObject = functionproxy(isLuaPiObject),
        loadstring = functionproxy(loadstring),
        rawtable_find = functionproxy(rawtable_find),
        table_find = functionproxy(table_find),
        reverse_table = functionproxy(reverse_table),
        base_table = functionproxy(base_table),
        terminator = functionproxy(terminator),
        rawget = functionproxy(function(t,k)
            if not isproxy(t) then
                return _rawget(t,k)
            else error("proxy object")
            end
        end),
        rawset = functionproxy(function(t,k,v)
            if not isproxy(t) then
                return _rawset(t,k,v)
            else error("proxy object")
            end
        end),
        rawlen = functionproxy(function(t)
            if not isproxy(t) then
                return _rawlen(t)
            else error("proxy object")
            end
        end),
    })
    return env
end