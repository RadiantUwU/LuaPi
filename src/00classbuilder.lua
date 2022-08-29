local ClassBuilder = nil
do
    local function base_obj(cls)
        return {
            cls_builder__type="base",
            cls=cls
        }
    end
    local function metaclass(cls)
        return {
            cls_builder__type="metaclass",
            cls=cls
        }
    end
    local final = {cls_builder__type="final"}
    local field = {}
    table.freeze(final)
    local function _static(o)
        o.cls_builder__static = true
        return o
    end
    local function static(accessor)
        return function (str:string)
            return _static(accessor(str))
        end
    end
    local function extends(...)
        local t = {}
        for _,v in ipairs(table.pack(...)) do
            if v.cls_builder__type == "metaclass" then
                table.insert(t,v)
                continue
            end
            table.insert(t,base_obj(v))
        end
        return unpack(t)
    end
    local dictset = function (dict:{[string]:any},pre,func,cls_name,metaclass,processed_bases,isfinal)
        local newdict = {}
        for k,v in pairs(dict) do
            if type(k) == "string" then
                newdict[k] = v
            elseif type(k) == "table" then
                if k.cls_builder__type=="private" then
                    newdict[k] = v
                elseif k.cls_builder__type=="protected" then
                    newdict[k] = v
                elseif k.cls_builder__type=="public" then
                    newdict[k] = v
                else
                    error("Invalid field.")
                end
            end
        end
        if #pre > 0 then
            return func(unpack(pre),cls_name,metaclass,processed_bases,isfinal,newdict)
        else
            return func(cls_name,metaclass,processed_bases,isfinal,newdict)
        end
    end
    local function class_func_custom(func,...)
        local pre = table.pack(...)
        local function class_builder(cls_name: string)
            return function (...)
                local bases = table.pack(...)
                local processed_bases = {}
                local metaclass = nil
                local isfinal = false
                for _,v in ipairs(bases) do
                    if type(v) == "string" then
                        return dictset(bases,func,cls_name,metaclass,{},isfinal)
                    else
                        if v.cls_builder__type == "public" or v.cls_builder__type == "protected" or v.cls_builder__type == "private" then
                            return dictset(bases,func,cls_name,metaclass,{},isfinal)
                        end
                        if v.cls_builder__type == "metaclass" then
                            metaclass = v.cls
                        elseif v.cls_builder__type == "final" then
                            isfinal = true
                        else
                            table.insert(processed_bases,v.cls)
                        end
                    end
                end
                return function(dict:{[string]:any})
                    return dictset(dict,pre,func,cls_name,metaclass,processed_bases,isfinal)
                end
            end
        end
        return class_builder
    end
    local function private(str: string)
        return {
            cls_builder__type="private",
            str=str
        }
    end
    local function protected(str: string)
        return {
            cls_builder__type="protected",
            str=str
        }
    end
    local function public(str: string)
        return {
            cls_builder__type="public",
            str=str
        }
    end
    ClassBuilder =  {
        metaclass = metaclass,
        extends = extends,
        class_func_custom = class_func_custom,
        final=final,
        protected=protected,
        public=public,
        private=private,
        static=static,
        field=field
    }
end

--[[
Examples of usage:
    class "A" {<fields>}
    class "A" (extends (B)) {<fields>}
    class "A" (extends (B, C)) {<fields>}
    class "A" (extends (B, C), final) {<fields>}
    class "A" (extends (B, C), final, metaclass(type)) {<fields>}

Fields:
    [public "A"] = function () end -- public method in class
    [static(public) "A"] = function () end -- public function in class
    [protected "A"] = function () end -- protected method in class
    ...

]]--