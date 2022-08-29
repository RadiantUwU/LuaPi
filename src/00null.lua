local null
if _isLuau then
    null = newproxy(false)
else
    null = setmetatable({},{__index = function(self,k)
        return self
    end, __newindex = function(self,k,v) error("cannot edit frozen table.") end,__metatable = false,})
end