This is a fork of LuaNXML with LuaCATS annotations and a few bugfixes. 

LuaNXML
===

LuaNXML is a Lua port of [NXML](https://github.com/XWitchProject/NXML).

NXML is a pseudo-XML parser that can read and write the oddly formatted and often invalid XML files from [Noita](https://noitagame.com). NXML (the C#/.NET version linked before) is itself a port of the XML parser from [Poro](https://github.com/gummikana/poro), which is used by the custom Falling Everything engine on which Noita runs.

In short, LuaNXML is an XML parser that is 100% equivalent to Noita's parser. As opposed to something like [xml2lua](https://github.com/manoelcampos/xml2lua), LuaNXML is just as non-conformant to the XML specification as Noita itself. It can also produce semantically equivalent output in the form of a string.

# Example

The code below enables all mods in the `mod_config.xml` file by setting the `enabled` attribute on all children to `true`. Boolean values are automatically converted to Noita XML style `"1"` or `"0"` values when `:set` is used.

```lua
---@type nxml
local nxml = require("nxml")

---@param path string
---@return string
local function read(path)
	local f = io.open(path, "r")
	local content = f:read("*a")
	f:close()
	return content
end

---@param path string
---@param content string
local function write(path, content)
	local f = io.open(path, "w")
	f:write(content)
	f:close()
end

for content in nxml.edit_file("save00/mod_config.xml", read, write) do
	for elem in content:each_child() do
		elem:set("enabled", true)
	end
end
```

# API

The api of NXML is entirely documented within the code via [LuaCATS](https://luals.github.io/wiki/annotations/) so your editor should provide autocomplete and type checking for all of NXMLs features.
