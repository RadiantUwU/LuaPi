local locked = false
local _getfenv = getfenv
local _setfenv = setfenv
local _error = error
local function _print(...)
    print("[deprecategetfenv]",...)
end
local module = {}
local authorized = {}

function module.authorize(f)
    if not locked then
        authorized[f] = true
    else
        _error("module locked")
    end
end

function module.lock()
    if not locked then
        table.freeze(authorized)
        locked = true
        local global = _G
        global.getfenv = function(f)
            if authorized[f] then
                if type(f) == "number" then
                    return _getfenv(f + 1)
                else
                    return _getfenv(f)
                end
            else
                _error("not authorized")
            end
        end
        global.setfenv = function(f, env)
            if authorized[f] then
                if type(f) == "number" then
                    return _setfenv(f + 1, env)
                else
                    return _setfenv(f, env)
                end
            else
                _error("not authorized")
            end
        end
        _print("locked")
    end
end
table.freeze(module)
return module