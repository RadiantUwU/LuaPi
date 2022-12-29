end
return setmetatable({},{__index=__luapi,__metatable=false})
end
if _isLuau then
  return loadLuaPiModule()
end

local function tableextend(src,dst)
    for k,v in pairs(src) do
        dst[k] = v
    end
    return dst
end
loadLuaPiModule()
local luapi = __luapi
dbg()
local sandbox = luapi.newSandbox()
local function test()
    print(object)
    print(object())
end
local env = sandbox.getfenv(test)
tableextend(sandbox,env)
test()