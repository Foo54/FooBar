-- Code from https://github.com/TheOneGoofAli/TOGAPackBalatro

-- Out-of-the-Box crossmod content.

local basecrossmod = {
	next(SMODS.find_mod('aikoyorisshenanigans')) and 'aikoshen.lua',
}

-- If none of these are valid, stop here.
if not next(basecrossmod) then sendInfoMessage("No eligible mods found, aborting...", "FooBar"); return end

sendInfoMessage("Loading Cross-Mod content...", "FooBar")
for _, file in pairs(basecrossmod) do
	sendDebugMessage("Executing module/crossmod/"..file, "FooBar - Crossmod")
	assert(SMODS.load_file("module/crossmod/"..file))()
end