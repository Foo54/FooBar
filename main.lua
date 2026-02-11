--- STEAMODDED HEADER
--- MOD_NAME: FooBar
--- MOD_ID: foobar
--- PREFIX: foobar
--- MOD_AUTHOR: [Foo54]
--- MOD_DESCRIPTION: Foo54's own creation where I put random ideas I have in it.
--- LOADER_VERSION_GEQ: 1.0.0
--- VERSION: 1.0.0
--- BADGE_COLOR: 222222


--- file loading taken from Cryptid
local mod_path = "" .. SMODS.current_mod.path
local files = NFS.getDirectoryItems(mod_path .. "module")
for _, file in ipairs(files) do
	print("FooBar | Loading module file " .. file)
	local f, err = SMODS.load_file("module/" .. file)
	if err then
		error(err)
	end
	return f()
end

