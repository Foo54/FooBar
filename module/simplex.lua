local DEF_PROB = "foobar_default_probability"

--- 8 Ball
FooBar.take_ownership_nth_trigger(
	"8_ball",
	function (self, card, context) return context.individual and context.cardarea == G.play and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and context.other_card:get_id() == 8 end,
	{DEF_PROB},
	{"extra"},
	function (self, card, context)
		G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
		return {
			extra = {
				message = localize('k_plus_tarot'),
				message_card = card,
				func = function() -- This is for timing purposes, everything here runs after the message
					G.E_MANAGER:add_event(Event({
						func = (function()
							SMODS.add_card{
								set = 'Tarot'
							}
							G.GAME.consumeable_buffer = 0
							return true
						end)
					}))
				end
			},
		}
	end,
	"j_foobar_8_ball"
)

--- Gros Michel
local grosrefcalc = SMODS.Joker:get_obj("j_gros_michel").calculate or function() end
local grosreflocvars = SMODS.Joker:get_obj("j_gros_michel").loc_vars or function() end
SMODS.Joker:take_ownership("gros_michel", {
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and FooBar.average_probability() then
			local num, dem = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "gros_michel")
			card.ability.foobar_counter = (card.ability.foobar_counter or 0) + num
			if card.ability.foobar_counter >= dem then
				SMODS.destroy_cards(card, nil, nil, true)
				G.GAME.pool_flags.gros_michel_extinct = true
				return {
						message = localize('k_extinct_ex')
				}
			end
			return {
				message = localize('k_safe_ex')
			}
		end
		return grosrefcalc(self, card, context)
	end,
	loc_vars = function(self, local_queue, card)
		if FooBar.average_probability() then
			local num, dem = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "gros_michel")
			return {
				key = "j_foobar_gros_michel",
				vars = {card.ability.extra.mult, dem - (card.ability.foobar_counter or 0), num}
			}
		end
		return grosreflocvars(self, local_queue, card)
	end
}, true)

--- Business Card
FooBar.take_ownership_expected_value(
	"business",
	function(self, card, context) return context.individual and context.cardarea == G.play and context.other_card:is_face() end,
	{{DEF_PROB}},
	{{"extra"}},
	{{key = "dollars", value = 0}},
	{{key = "dollars", value = 2}},
	"j_foobar_or_business"
)


--- Space Joker
FooBar.take_ownership_nth_trigger(
	"space",
	function (self, card, context) return context.before end,
	{DEF_PROB},
	{"extra"},
	function (self, card, context)
		return {
			level_up = true,
			message = localize('k_level_up_ex')
		}
	end,
	"j_foobar_or_space"
)


--- Cavendish
local cavrefcalc = SMODS.Joker:get_obj("j_cavendish").calculate or function() end
local cavreflocvars = SMODS.Joker:get_obj("j_cavendish").loc_vars or function() end
SMODS.Joker:take_ownership("cavendish", {
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and FooBar.average_probability() then
			local num, dem = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "cavendish")
			card.ability.foobar_counter = (card.ability.foobar_counter or 0) + num
			if card.ability.foobar_counter >= dem then
				SMODS.destroy_cards(card, nil, nil, true)
				return {
						message = localize('k_extinct_ex')
				}
			end
			return {
				message = localize('k_safe_ex')
			}
		end
		return cavrefcalc(self, card, context)
	end,
	loc_vars = function(self, local_queue, card)
		if FooBar.average_probability() then
			local num, dem = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "cavendish")
			return {
				key = "j_foobar_or_cavendish",
				vars = {card.ability.extra.Xmult, dem - (card.ability.foobar_counter or 0), num}
			}
		end
		return cavreflocvars(self, local_queue, card)
	end
}, true)


--- Reserved Parking
FooBar.take_ownership_expected_value(
	"reserved_parking",
	function(self, card, context) return context.individual and context.cardarea == G.hand and not context.end_of_round and context.other_card:is_face() end,
	{{DEF_PROB}},
	{{"extra", "odds"}},
	{{key = "dollars", value = 0}},
	{{key = "dollars", path = {"extra", "dollars"}}},
	"j_foobar_or_reserved_parking"
)


--- Hallucination
FooBar.take_ownership_nth_trigger(
	"hallucination",
	function (self, card, context) return context.open_booster and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit end,
	{DEF_PROB},
	{"extra"},
	function (self, card, context)
		G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
		return {
			extra = {
				message = localize('k_plus_tarot'),
				message_card = card,
				func = function() -- This is for timing purposes, everything here runs after the message
					G.E_MANAGER:add_event(Event({
						func = (function()
							SMODS.add_card{
								set = 'Tarot'
							}
							G.GAME.consumeable_buffer = 0
							return true
						end)
					}))
				end
			},
		}
	end,
	"j_foobar_or_hallucination"
)


--- Bloostone
FooBar.take_ownership_expected_value(
	"bloodstone",
	function(self, card, context) return context.individual and context.cardarea == G.play and context.other_card:is_suit("Hearts") end,
	{{DEF_PROB}},
	{{"extra", "odds"}},
	{{key = "Xmult", value = 1}},
	{{key = "Xmult", path = {"extra", "Xmult"}}},
	"j_foobar_or_bloodstone"
)


--- Glass
local glassrefcalc = SMODS.Enhancement:get_obj("m_glass").calculate or function() end
local glassreflocvars = SMODS.Enhancement:get_obj("m_glass").loc_vars or function(self, info_queue, card)
	local num, dem = SMODS.get_probability_vars(card, card.ability.foobar_numerator or 1, card.ability.extra, "glass")
	return {vars={card.ability.Xmult, num, dem}}
end
SMODS.Enhancement:take_ownership("m_glass", {
	calculate = function(self, card, context)
		if context.destroy_card and context.cardarea == G.play and context.destroy_card == card and FooBar.average_probability() then
			local num, dem = SMODS.get_probability_vars(card, card.ability.foobar_numerator or 1, card.ability.extra, "glass")
			card.ability.foobar_counter = (card.ability.foobar_counter or 0) + num
			if card.ability.foobar_counter >= dem then
				card.glass_trigger = true -- SMODS addition
				return { remove = true }
			end
			return {}
		end
		return glassrefcalc(self, card, context)
	end,
	loc_vars = function(self, info_queue, card)
		if FooBar.average_probability() then
			local num, dem = SMODS.get_probability_vars(card, card.ability.foobar_numerator or 1, card.ability.extra, "glass")
			return {
				key = "m_foobar_or_glass",
				vars = {card.ability.Xmult, dem - (card.ability.foobar_counter or 0), num}
			}
		end
		return glassreflocvars(self, info_queue, card)
	end
}, true)


--- Lucky
local luckyrefcalc = SMODS.Enhancement:get_obj("m_lucky").calculate or function() end
local luckyreflocvars = SMODS.Enhancement:get_obj("m_lucky").loc_vars or function(self, info_queue, card)
	local num_mult, dem_mult = SMODS.get_probability_vars(card, 1, 5, 'lucky_mult')
	local num_money, dem_money = SMODS.get_probability_vars(card, 1, 15, 'lucky_money')
	return {
		vars = {num_mult, num_money, card.ability.mult, dem_mult, card.ability.p_dollars, dem_money}
	}
end
SMODS.Enhancement:take_ownership("m_lucky", {
	calculate = function(self, card, context)
		if context.main_scoring and context.cardarea == G.play and FooBar.average_probability() then
			local num_mult, dem_mult = SMODS.get_probability_vars(card, 1, 5, 'lucky_mult')
			num_mult = math.min(num_mult, dem_mult)
			local num_money, dem_money = SMODS.get_probability_vars(card, 1, 15, 'lucky_money')
			num_money = math.min(num_money, dem_money)
			return {
				mult = num_mult * card.ability.mult / dem_mult,
				dollars = num_money * card.ability.p_dollars / dem_money
			}
		end
		if not FooBar.average_probability() then
			return luckyrefcalc(self, card, context)
		end
	end,
	loc_vars = function(self, info_queue, card)
		if FooBar.average_probability() then
			local num_mult, dem_mult = SMODS.get_probability_vars(card, 1, 5, 'lucky_mult')
			num_mult = math.min(num_mult, dem_mult)
			local num_money, dem_money = SMODS.get_probability_vars(card, 1, 15, 'lucky_money')
			num_money = math.min(num_money, dem_money)
			return {
				key = "m_foobar_or_lucky",
				vars = {num_mult * card.ability.mult / dem_mult, num_money * card.ability.p_dollars / dem_money}
			}
		end
		return luckyreflocvars(self, info_queue, card)
	end
}, true)


--- Wheel of fortune
local wofrefuse = SMODS.Tarot:get_obj("c_wheel_of_fortune").use or function() end
local wofreflocvars = SMODS.Tarot:get_obj("c_wheel_of_fortune").loc_vars or function(self, info_queue, card)
	for index, value in ipairs({"foil", "holo", "polychrome"}) do
		info_queue[#info_queue + 1] = G.P_CENTERS["e_" .. value]
	end
	local num, dem = SMODS.get_probability_vars(card, 1, card.ability.extra, "wheel_of_fortune")
	return {vars = {num, dem}}
end
SMODS.Tarot:take_ownership("c_wheel_of_fortune", {
	use = function(self, card, area, copier)
		if FooBar.average_probability() then
			local num, dem = SMODS.get_probability_vars(card, 1, card.ability.extra, "wheel_of_fortune")
			G.GAME.foobar_wheel_counter = ((G.GAME.foobar_wheel_counter or 0) + 1) % dem
			if G.GAME.foobar_wheel_counter < num then
				local editionless_jokers = SMODS.Edition:get_edition_cards(G.jokers, true)

				local eligible_card = pseudorandom_element(editionless_jokers, 'vremade_wheel_of_fortune')
				local edition = SMODS.poll_edition { key = "vremade_wheel_of_fortune", guaranteed = true, no_negative = true, options = { 'e_polychrome', 'e_holo', 'e_foil' } }
				eligible_card:set_edition(edition, true)
				check_for_unlock({ type = 'have_edition' })
			else
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.4,
					func = function()
						attention_text({
							text = localize('k_nope_ex'),
							scale = 1.3,
							hold = 1.4,
							major = card,
							backdrop_colour = G.C.SECONDARY_SET.Tarot,
							align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
								'tm' or 'cm',
							offset = { x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0 },
							silent = true
						})
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.06 * G.SETTINGS.GAMESPEED,
							blockable = false,
							blocking = false,
							func = function()
								play_sound('tarot2', 0.76, 0.4)
								return true
							end
						}))
						play_sound('tarot2', 1, 0.4)
						card:juice_up(0.3, 0.5)
						return true
					end
				}))
			end
		else
			wofrefuse(self, card, area, copier)
		end
	end,
	loc_vars = function(self, info_queue, card)
		if FooBar.average_probability() then
			local num, dem = SMODS.get_probability_vars(card, 1, card.ability.extra, "wheel_of_fortune")
			for index, value in ipairs({"foil", "holo", "polychrome"}) do
				info_queue[#info_queue + 1] = G.P_CENTERS["e_" .. value]
			end
			return {
				key = "c_foobar_or_wheel_of_fortune",
				vars = {num, dem, (G.GAME.foobar_wheel_counter or 0) + 1}
			}
		end
		return wofreflocvars(self, info_queue, card)
	end
}, true)


--- The Wheel
local wheelrefcalc = SMODS.Blind:get_obj("bl_wheel").use or function() end
SMODS.Blind:take_ownership("bl_wheel", {
	calculate = function(self, blind, context)
		if not blind.disabled then
			if context.stay_flipped and context.to_area == G.hand and FooBar.average_probability() then
				local num, dem = SMODS.get_probability_vars(blind, 1, 7, "wheel")
				if not blind.effect then blind.effect = {} end
				blind.effect.foobar_counter = ((blind.effect.foobar_counter or 0) + 1) % dem
				if blind.effect.foobar_counter < num then
					return {
						stay_flipped = true
					}
				end
			end
			return {}
		end
		return wheelrefcalc(self, blind, context)
	end
}, true)

