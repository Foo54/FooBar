--- STEAMODDED HEADER
--- MOD_NAME: FooBar
--- MOD_ID: foobar
--- PREFIX: foobar
--- MOD_AUTHOR: [Foo54]
--- MOD_DESCRIPTION: Foo54's own creation where I put random ideas I have in it.
--- LOADER_VERSION_GEQ: 0.5.1dev
--- VERSION: 0.5.1dev
--- BADGE_COLOR: 222222

if not FooBar then FooBar = {} end

--- file loading taken from Cryptid
local mod_path = "" .. SMODS.current_mod.path

print("Foobar | Loading utils.lua")
local f, err = SMODS.load_file("utils.lua")
if err then
	error(err)
end
f()

local files = NFS.getDirectoryItems(mod_path .. "module")
for _, file in ipairs(files) do
	print("FooBar | Loading module file " .. file)
	local f, err = SMODS.load_file("module/" .. file)
	if err then
		error(err)
	end
	f()
end

SMODS.current_mod.calculate = function(self, context)
	if context.modify_shop_card then
		if context.card.config.center.key == "j_foobar_graphics_card" then
			G.GAME.foobar_inflation = (G.GAME.foobar_inflation or 0) + 1
		end
	end
end

SMODS.current_mod.description_loc_vars = function()
    return { background_colour = G.C.CLEAR, text_colour = G.C.WHITE, scale = 1.2 }

end

