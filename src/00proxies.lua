local proxies = setmetatable({},{__mode="k"})

local addproxy = function(o) --[[
    Proxies are used to not allow running `raw` operations.
]]--
    proxies[o] = true
end
local isproxy = function(o) --[[
    Returns true if the object is a proxy.
]]--
    return proxies[o]
end