local nxml = require("nxml")
local tree = nxml.parse(
	[[<Entity name="hi"> <LuaComponent script_source_file="hamis_code.lua"> </LuaComponent> <DamageModelComponent hp="9999"> </DamageModelComponent> </Entity>]]
)
print(tree.attr.name)
for element in tree:each_of("LuaComponent") do
	print(element.attr["script_source_file"])
end

for element in tree:each_child() do
	print(element)
end

print(tree:first_of("LuaComponent").attr["script_source_file"])

print(tostring(tree))
print(nxml.tostring(tree, true))
tree:add_child(nxml.parse("<Entity />"))
print(tree)

local dup_name = nxml.parse([[<Entity name="a" name="b" />]])
assert(dup_name.attr.name == "a")

---@type {[string]: string}
local vfs = {}

---@param filename string
---@return string?
local function read(filename)
	return vfs[filename]
end

---@param filename string
---@return bool
local function exists(filename)
	return vfs[filename] ~= nil
end

---@param filename string
---@param content string
local function write(filename, content)
	vfs[filename] = content
end
for _ = 1, 10 do
	print("")
end
print("===============================")
for _ = 1, 10 do
	print("")
end

local dmc = nxml.new_element("DamageModelComponent", { hp = "0.01" })
local base = nxml.new_element("Base", { file = "enemy" }, { dmc })
local hamis = nxml.new_element("Entity", { name = "hamis" }, { base })

local enemy = nxml.new_element(
	"Entity",
	{ name = "enemy" },
	{ nxml.new_element("DamageModelComponent", { hp = "999", max_hp = "2" }) }
)

enemy:create_children({
	LifetimeComponent = {
		lifetime = 300,
	},
})

vfs.enemy = tostring(enemy)
hamis:expand_base(read, exists)
assert(hamis:first_of("DamageModelComponent"):get("hp") == "0.01")
assert(hamis:first_of("DamageModelComponent"):get("max_hp") == "2")
print(hamis)
local evil_hamis = hamis:clone()
evil_hamis:first_of("DamageModelComponent"):set("hp", -1)
assert(hamis:first_of("DamageModelComponent"):get("hp") == "0.01")
assert(enemy:first_of("LifetimeComponent"):get("lifetime") == "300")

---@return string
local function arbitrary_str()
	local s = ""
	for _ = 1, math.random(10) do
		s = s .. string.char(math.random(26) + 0x60)
	end
	return s
end

local function arbitrary_table()
	local t = {}
	for _ = 1, math.random(10) do
		t[arbitrary_str()] = arbitrary_str()
	end
	return t
end

local function arbitrary_el(n)
	n = n or 1
	local children = {}
	if math.random(1, math.floor(n)) == math.floor(n) then
		for _ = 1, math.random(10) do
			table.insert(children, arbitrary_el(n * 2))
		end
	end
	return nxml.new_element(arbitrary_str(), arbitrary_table(), children)
end

local sock = require("socket")
--[[
for _ = 1, 10 do
	local el = arbitrary_el(1)
	print(el)
	local start = sock.gettime()
	to_string_internal(el, false, "\t", "", {})
	local fin = sock.gettime()
	print(fin - start, "old")

	start = sock.gettime()
	to_string_internal2(el, false, "\t", "")
	fin = sock.gettime()
	print(fin - start, "new")
end
]]
-- print(arbitrary_el())
arbitrary_el()

write("test.xml", [[<Entity name="fish"/>]])
for content in nxml.edit_file("test.xml", read, write) do
	content:set("name", "banana")
end
assert(nxml.parse(read("test.xml") or ""):get("name") == "banana")
