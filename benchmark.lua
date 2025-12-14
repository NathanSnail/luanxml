local socket = require("socket")
local nxml = require(arg[3])
local path = arg[1]
local count = tonumber(arg[2])
local content = io.open(path, "r"):read("*a")
local tree = nxml.parse(content)
local start = socket.gettime()
for _ = 1, count do
	local s = tostring(tree)
	if s:len() == 0 then
		error("never happens")
	end
	jit.flush()
end
local fin = socket.gettime()
print(fin - start)
