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
