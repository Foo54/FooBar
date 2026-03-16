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
assert(SMODS.load_file("module/priority/utils.lua"))()

local files = NFS.getDirectoryItems(mod_path .. "module")
for _, file in ipairs(files) do
	if file:match(".lua$") then
		print("FooBar | Loading module file " .. file)
		assert(SMODS.load_file("module/" .. file))()
	end
end

--[[
don't do this yet
print("Foobar | Loading minigame.lua")
assert(SMODS.load_file("module/priority/minigame.lua"))()

local files = NFS.getDirectoryItems(mod_path .. "module/minigame")
for _, file in ipairs(files) do
	if file:match(".lua$") then
		print("FooBar | Loading minigame file " .. file)
		assert(SMODS.load_file("module/minigame/" .. file))()
	end
end
]]

print("Foobar | Loading crossmod.lua")
assert(SMODS.load_file("module/priority/crossmod.lua"))()

SMODS.current_mod.description_loc_vars = function()
    return { background_colour = G.C.CLEAR, text_colour = G.C.WHITE, scale = 1.2 }
end