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
		lifetime = 300
	}
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
