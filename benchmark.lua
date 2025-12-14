local socket = require("socket")
local nxml = require(arg[3]) --[[@as nxml]]
local path = arg[1]
local count = tonumber(arg[2])
local content = io.open(path, "r"):read("*a")
local start = socket.gettime()
for _ = 1, count do
	local tree = nxml.parse(content)
	if tree.name == "" then
		error("never happens")
	end
	jit.flush()
end
local fin = socket.gettime()
print(fin - start)
