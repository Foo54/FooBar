
local function use_voicebank(_vb, card, area, copier, disable, enable)
	if card.ability.immutable._active then
		SMODS.destroy_cards(card)
		if disable then disable() end
	else
		local destroy = {}
		for _, vb in ipairs(G.consumeables.cards) do
			if vb.config.center.set == "Voicebank" then
				if vb.ability.immutable._active then
					table.insert(destroy, vb)
				end
			end
		end
		SMODS.destroy_cards(destroy)
		card.ability.immutable._active = true
		card:set_edition("e_foobar_working")
		if enable then enable() end
	end
end

SMODS.ConsumableType{
	key = "Voicebank",
	primary_colour = HEX("141414"),
	secondary_colour = HEX("F58727"),
	collection_rows = { 5, 5 },
	shop_rate = 3,
	default = "c_foobar_vb_meiko",
	inject_card = function(self, card)
		card.can_use = card.can_use or function(self, card) return true end
		card.keep_on_use = card.keep_on_use or function(self, card) return not card.ability.immutable._active end
		card.use = card.use or use_voicebank
	end
}

local function add_vb_info (info_queue)
	info_queue[#info_queue + 1] = {set = "Other", key = "foobar_vb_info", vars = {colours = {SMODS.ConsumableTypes.Voicebank.secondary_colour}}}
end
local function generate_active_status (active)
	if not active then
		return {n = G.UIT.R, config = { padding = 0.1, colour = G.C.RED, r = 0.1}, nodes = {
		{n = G.UIT.T, config = {scale = 0.3, text = "Inactive"}}
	}}
end
end

SMODS.Edition{
	key = "working",
	shader = false,
	no_collection = true,
	in_shop = false,
	badge_colour = G.C.GREEN,
	config = {card_limit = 1}
}


SMODS.Consumable{
	key = "vb_meiko",
	set = "Voicebank",
	atlas = "voicebanks",
	pos = {x=1, y=0},
	pixel_size = {h = 66 + 20},
	config = {
		extra = {
			num = 1,
			dem = 2
		},
		immutable = {
			suit = "Hearts",
			_active = false,
			counter = 0
		}
	},
	loc_vars = function(self, info_queue, card)
		add_vb_info(info_queue)
		local num, dem = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.dem, "meiko_debuff")
		local main_end = generate_active_status(card.ability.immutable._active)
		local ret = {vars = {card.ability.immutable.suit, num, dem}}
		if FooBar.average_probability() then ret.key = self.key .. "_simplex" end
		if main_end then ret.main_end = {main_end} end
		return ret
	end,
	use = function(self, card, area, copier)
		use_voicebank(self, card, area, copier, nil, function() FooBar.recalculate_debuffs() end)
	end,
	calculate = function(self, card, context)
		if card.ability.immutable._active then
			if context.repetition then
				if context.other_card:is_suit("Hearts") then
					return {
						repetitions = 1
					}
				end
			end
			if context.debuff_card then
				if not context.debuff_card:is_suit("Hearts") then
					local flag = false
					if FooBar.average_probability() then
						local num, dem = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.dem, "meiko_debuff")
						card.ability.immutable.counter = (card.ability.immutable.counter + 1) % dem
						flag = card.ability.immutable.counter < num
					else
						flag = SMODS.pseudorandom_probability(card, "meiko_debuff", card.ability.extra.num, card.ability.extra.dem)
					end
					if flag then
						return {
							debuff = true
						}
					end
				end
			end
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		if card.ability.immutable._active then
			FooBar.recalculate_debuffs()
		end
	end
}

SMODS.Consumable{
	key = "vb_kaito",
	set = "Voicebank",
	atlas = "voicebanks",
	pos = {x=2,y=0},
	pixel_size = {h = 66 + 20},
	config = {
		extra = {
			chips_gain = 10,
			mult_gain = 1
		},
		immutable = {
			_active = false,
			suit = "Clubs"
		}
	},
	loc_vars = function(self, info_queue, card)
		add_vb_info(info_queue)
		local main_end = generate_active_status(card.ability.immutable._active)
		local ret = {vars = {card.ability.immutable.suit, card.ability.extra.chips_gain, card.ability.extra.mult_gain}}
		if main_end then ret.main_end = {main_end} end
		return ret
	end,
	calculate = function(self, card, context)
		if card.ability.immutable._active then
			if context.before then
				for _, _card in ipairs(context.scoring_hand) do
					if _card:is_suit(card.ability.immutable.suit) then
						--if not _card.ability.bonus_chips then _card.ability.bonus_chips = 0 end
						--if not _card.ability.bonus_mult then _card.ability.bonus_mult = 0 end
						SMODS.scale_card(_card, {
							ref_table = _card.ability,
							ref_value = "perma_bonus",
							scalar_table = card.ability.extra,
							scalar_value = "chips_gain"
						})
						SMODS.scale_card(_card, {
							ref_table = _card.ability,
							ref_value = "perma_mult",
							scalar_table = card.ability.extra,
							scalar_value = "mult_gain"
						})
					end
				end
			end
		end
	end
}