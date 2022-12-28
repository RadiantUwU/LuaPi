local _weakref = setmetatable({},{__mode="kv",__metatable=false})
local _weakref_funcs = {
    get=function(self)
        return _weakref[self]
    end,
    set=function(self,value)
        _weakref[self] = value
    end,
}
local _weakref_mt = {__metatable=false,__newindex=function(t,k,v)
    error()
end,__index=_weakref_funcs}
local weakref = setmetatable({},{__metatable=false,__index={
    new = function(o)
        local r = setmetatable({},_weakref_mt)
        _weakref[r] = o
        return r
    end
},__newindex=function(t,k,v)
    error()
end})