--- Split Dance
SMODS.Joker{
	key = "splitdance",
	atlas = "jokers",
	pos = {x=12,y=1},
	rarity = 2,
	cost = 7,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.e_akyrs_sliced
		return {}
	end,
	pools = {["aiko"] = true, ["Song"] = true}
}