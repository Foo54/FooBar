--- STEAMODDED HEADER
--- MOD_NAME: FooBar
--- MOD_ID: foobar
--- PREFIX: foobar
--- MOD_AUTHOR: [Foo54]
--- MOD_DESCRIPTION: Foo54's own creation where I put random ideas I have in it.
--- LOADER_VERSION_GEQ: 0.8dev
--- VERSION: 0.8dev
--- BADGE_COLOR: 222222

if not FooBar then FooBar = {} end

--- file loading taken from Cryptid
local mod_path = "" .. SMODS.current_mod.path

SMODS.current_mod.optional_features = function()
	return {
		quantum_enhancements = true,
		cardareas = {
			deck = true
		}
	}
end

print("Foobar | Loading utils.lua")
local f, err = SMODS.load_file("module/priority/utils.lua")
if err then
	error(err)
end
f()

local files = NFS.getDirectoryItems(mod_path .. "module")
for _, file in ipairs(files) do
	if file:match(".lua$") then
		print("FooBar | Loading module file " .. file)
		local f, err = SMODS.load_file("module/" .. file)
		if err then
			error(err)
		end
		f()
	end
end

print("Foobar | Loading crossmod.lua")
local f, err = SMODS.load_file("module/priority/crossmod.lua")
if err then
	error(err)
end
f()

SMODS.current_mod.description_loc_vars = function()
    return { background_colour = G.C.CLEAR, text_colour = G.C.WHITE, scale = 1.2 }
end