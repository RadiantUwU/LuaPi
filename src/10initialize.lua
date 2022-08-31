local initenv
do
    local metaclass = ClassBuilder.metaclass
    local extends = ClassBuilder.extends
    local final = ClassBuilder.final
    local protected = ClassBuilder.protected
    local public = ClassBuilder.public
    local private = ClassBuilder.private
    local static = ClassBuilder.static
    local field = ClassBuilder.field

    function initenv(class,env)
        dobaseobj(class,env) --create base object env.object
        dobasetype(class,env)  --create base type env.basetype
        objinfo[env.object].frozen = true
        objinfo[env.basetype].frozen = true
        objinfo[env.object].type = env.basetype
        objinfo[env.basetype].type = env.basetype
        objinfo[env.basetype].bases = {env.object}
        objinfo[env.basetype].mro = {env.basetype,env.object}
        objinfo[env.basetype].fields = (function(...) 
            local fieldst = reverse_table(table.pack(...))
            local fields = {}
            for _,cls in ipairs(fieldst) do 
                for k,v in pairs(objinfo[cls].fields) do
                    fields[k] = v
                end
            end
            return fields
        end)(env.basetype,env.object)
    end
end