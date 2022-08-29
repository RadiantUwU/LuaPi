local _loadstring = loadstring
local loadstring

if _isLuau then
    loadstring = LoadstringModule()
else
    loadstring = _loadstring
end