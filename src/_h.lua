local _newtable
local _isLuau
if game then
    if script then
        _isLuau = true
    else
        _isLuau = false
    end
else
    _isLuau = false
end

local __luapi = {}

if _isLuau then
    _newtable = function()
        return {}
    end
else
    _newtable = function()
        return {}
    end
end

local function loadLuaPiModule()
if #__luapi > 0 then return setmetatable({},{__index=__luapi,__metatable=false}) end