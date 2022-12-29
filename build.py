import os
import sys
"""
Lua file builder.
Args:
1. src folder
2. outfile
"""

assert len(sys.argv) == 3
path = sys.argv[1]
directory = os.listdir(path)
directory.sort()
spacer = "=" * 20
def writefile(fw,name):
    with open(path+"/"+name) as f:
        fw.write("--[[{}\n\t{}\n]]--{}\n\n".format(spacer,path+'/'+name,spacer))
        fw.write(f.read()+"\n\n")
with open(sys.argv[2],mode="w") as fw:
    writefile(fw,"_h.lua")
    for fn in directory:
        if fn == "_h.lua": continue
        if fn == "_f.lua": continue
        writefile(fw,fn)
    writefile(fw,"_f.lua")