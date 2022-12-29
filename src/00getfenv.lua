local getfenv = getfenv
local setfenv = setfenv
local getfunc
if _isLuau then
    function getfunc(level)
        return debug.info(level + 1, "f")
    end
else
    function getfunc(level)
        return debug.getinfo(level + 1, "f").func
    end
    function setfenv(fn, env)
        if type(fn) != "function" then
            fn = getfunc(fn + 1)
        end
        local i = 1
        while true do
            local name = debug.getupvalue(fn, i)
            if name == "_ENV" then
                debug.upvaluejoin(fn, i, (function() return env end), 1)
                break
            elseif not name then
                break
            end
            i = i + 1
        end
        return fn
    end
    function getfenv(fn)
        if type(fn) != "function" then
            fn = getfunc(fn + 1)
        end
        local i = 1
        while true do
            local name, val = debug.getupvalue(fn, i)
        if name == "_ENV" then
            return val
        elseif not name then
            break
        end
        i = i + 1
    end
end