--- TO ADD
--- Otomachi Una


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

SMODS.ConsumableType{
	key = "Voicebank",
	primary_colour = HEX("141414"),
	secondary_colour = HEX("F58727"),
	collection_rows = { 5, 5 },
	shop_rate = 3,
	default = "c_foobar_vb_defoko",
	inject_card = function(self, card)
		card.can_use = card.can_use or function(self, card) return true end
		card.keep_on_use = card.keep_on_use or function(self, card) return not card.ability.immutable._active end
		card.use = card.use or use_voicebank
		card.pixel_size = card.pixel_size or {h = 66 + 20}
		card.config = card.config or {}
		card.config.immutable = card.config.immutable or {}
		card.config.immutable._active = card.config.immutable._active or false
		local mem_loc_vars = card.loc_vars or function() return {} end
		card.loc_vars = function(_self, info_queue, _card)
			local main_end = nil
			if not _card.fake_card then
				add_vb_info(info_queue)
				main_end = generate_active_status(_card.ability.immutable._active)
			end
			local ret = mem_loc_vars(_self, info_queue, _card)
			if main_end then ret.main_end = ret.main_end or {main_end} end
			return ret
		end
		card.blueprint_compat = card.blueprint_compat == nil and true or card.blueprint_compat
	end
}


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
	config = {
		extra = {
			num = 1,
			dem = 2
		},
		immutable = {
			suit = "Hearts",
			counter = 0
		}
	},
	loc_vars = function(self, info_queue, card)
		local num, dem = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.dem, "meiko_debuff")
		local ret = {vars = {card.ability.immutable.suit, num, dem}}
		if FooBar.average_probability() then ret.key = self.key .. "_simplex" end
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
				if context.debuff_card.config.center.set == "Default" and not context.debuff_card:is_suit("Hearts") then
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
	config = {
		extra = {
			chips_gain = 10,
			mult_gain = 1
		},
		immutable = {
			suit = "Clubs"
		}
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.immutable.suit, card.ability.extra.chips_gain, card.ability.extra.mult_gain}}
	end,
	calculate = function(self, card, context)
		if card.ability.immutable._active then
			if context.before then
				for _, _card in ipairs(context.scoring_hand) do
					if _card:is_suit(card.ability.immutable.suit) then
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

SMODS.Consumable{
	key = "vb_rinlen",
	atlas = "voicebanks",
	pos = {x=3,y=0},
	set = "Voicebank",
	config = {
		extra = {
			money_gain = 1,
		}
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.money_gain}}
	end,
	calculate = function(self, card, context)
		if card.ability.immutable._active then
			if context.end_of_round and context.individual and context.cardarea == G.hand then
				SMODS.scale_card(card, {
					ref_table = context.other_card.ability,
					ref_value = pseudorandom_element({"perma_h_dollars", "perma_p_dollars"}, "rinlen_choice"),
					scalar_table = card.ability.extra,
					scalar_value = "money_gain"
				})
			end
		end
	end
}

SMODS.Consumable{
	key = "vb_miku",
	set = "Voicebank",
	atlas = "voicebanks",
	pos = {x=4,y=0},
	config = {
		extra = {
			xchips_gain = 0.1
		},
		immutable = {
			rank1 = 3,
			rank2 = 9
		}
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.immutable.rank1, card.ability.immutable.rank2, card.ability.extra.xchips_gain}}
	end,
	calculate = function(self, card, context)
		if card.ability.immutable._active then
			if context.before then
				for _, _card in ipairs(context.scoring_hand) do
					if _card:get_id() == card.ability.immutable.rank1 or _card:get_id() == card.ability.immutable.rank2 then
						SMODS.scale_card(_card, {
							ref_table = _card.ability,
							ref_value = "perma_x_chips",
							scalar_table = card.ability.extra,
							scalar_value = "xchips_gain"
						})
					end
				end
			end
		end
	end
}

SMODS.Consumable{
	key = "vb_luka",
	set = "Voicebank",
	atlas = "voicebanks",
	pos = {x=0,y=1},
	config = {
		extra = {
			extra_drawn = 2
		}
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.extra_drawn}}
	end,
	calculate = function(self, card, context)
		if card.ability.immutable._active then
			if context.hand_drawn or context.other_drawn then
				local hand = context.hand_drawn or context.other_drawn
				local rank = pseudorandom_element(hand, "luka_choice")
				if rank then
					rank = rank:get_id()
					local counter = 0
					for i=#G.deck.cards, 1, -1 do
						if G.deck.cards[i]:get_id() == rank then
							counter = counter + 1
							draw_card(G.deck, G.hand, 100/#G.hand.cards,'up', true, G.deck.cards[i],  0.08)
							if counter >= card.ability.extra.extra_drawn then break end
						end
					end
				end
			end
		end
	end
}

SMODS.Consumable{
	key = "vb_neru",
	set = "Voicebank",
	atlas = "voicebanks",
	pos = {x=1,y=1},
	config = {
		extra = {
			immutable = {
				copy_key = "c_foobar_vb_defoko"
			}
		}
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		local card_name = "None"
		if card.ability.immutable.copy_key then
			local _card = G.P_CENTERS[card.ability.immutable.copy_key]
			info_queue[#info_queue+1] = _card
			card_name = localize{type="name_text", set = "Voicebank", key=_card.key} or ("ERROR: " .. card.key)
		end
		return {vars = {card_name, colours = {SMODS.ConsumableTypes.Voicebank.secondary_colour}}}
	end,
	use = function(self, card, area, copier)
		use_voicebank(self, card, area, copier, nil, function()
			while true do
				card.ability.immutable.copy_key = pseudorandom_element(G.P_CENTER_POOLS.Voicebank, "neru_choice").key
				if card.ability.immutable.copy_key ~= card.config.center.key then break end
			end
		end)
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and context.main_eval then
			while true do
					card.ability.immutable.copy_key = pseudorandom_element(G.P_CENTER_POOLS.Voicebank, "neru_choice").key
					if card.ability.immutable.copy_key ~= card.config.center.key then break end
				end
		end
		if card.ability.immutable._active then
			if card.ability.immutable.copy_key then
				local ref = G.P_CENTERS[card.ability.immutable.copy_key]:create_fake_card()
				ref.ability.immutable._active = true
				ref.config = {center = {key = card.ability.immutable.copy_key}}
				local ret = G.P_CENTERS[card.ability.immutable.copy_key].calculate(ref, ref, context)
				if ret then
					ret.color = G.C.YELLOW
					ret.card = card
					return ret
				end
			end
		end
	end
}

SMODS.Consumable{
	key = "vb_sv_teto",
	atlas = "voicebanks",
	pos = {x=2,y=1},
	set = "Voicebank",
	config = {
		immutable = {
			hand = "Pair",
			suit = "Hearts"
		}
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.immutable.hand, card.ability.immutable.suit}}
	end,
	calculate = function(self, card, context)
		if card.ability.immutable._active then
			if context.before then
				if context.scoring_name == card.ability.immutable.hand then
					if #context.scoring_hand == 2 then
						if context.scoring_hand[1]:is_suit(card.ability.immutable.suit) and context.scoring_hand[2]:is_suit(card.ability.immutable.suit) then
							G.playing_card = (G.playing_card and G.playing_card + 1) or 1
							local card_copied_1 = copy_card(context.scoring_hand[1], nil, nil, G.playing_card)
							card_copied_1:add_to_deck()
							G.deck.config.card_limit = G.deck.config.card_limit + 1
							table.insert(G.playing_cards, card_copied_1)
							G.deck:emplace(card_copied_1)
							card_copied_1.states.visible = nil

							G.playing_card = (G.playing_card and G.playing_card + 1) or 1
							local card_copied_2 = copy_card(context.scoring_hand[2], nil, nil, G.playing_card)
							card_copied_2:add_to_deck()
							G.deck.config.card_limit = G.deck.config.card_limit + 1
							table.insert(G.playing_cards, card_copied_2)
							G.deck:emplace(card_copied_2)
							card_copied_2.states.visible = nil
							G.E_MANAGER:add_event(Event({
                func = function()
									card_copied_1:start_materialize()
									card_copied_2:start_materialize()
									return true
                end
							}))
							return {
								message = localize('k_copied_ex'),
								colour = G.C.RED,
								func = function() -- This is for timing purposes, it runs after the message
									G.E_MANAGER:add_event(Event({
										func = function()
											SMODS.calculate_context({ playing_card_added = true, cards = { card_copied_1, card_copied_2 } })
											return true
										end
									}))
								end
							}
						end
					end
				end
			end
		end
	end
}

SMODS.Consumable{
	key = "vb_utau_teto",
	set = "Voicebank",
	atlas = "voicebanks",
	pos = {x=3,y=1},
	config = {
		extra = {
			h_xmult_gain = 0.1
		},
		immutable = {
			suit = "Hearts"
		}
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.immutable.suit, card.ability.extra.h_xmult_gain}}
	end,
	calculate = function(self, card, context)
		if card.ability.immutable._active then
			if context.before then
				for _, _card in ipairs(context.scoring_hand) do
					if _card:is_suit(card.ability.immutable.suit) then
						SMODS.scale_card(_card, {
							ref_table = _card.ability,
							ref_value = "perma_h_x_mult",
							scalar_table = card.ability.extra,
							scalar_value = "h_xmult_gain"
						})
					end
				end
			end
		end
	end
}

SMODS.Consumable{
	set = "Voicebank",
	key = "vb_momone",
	atlas = "voicebanks",
	pos = {x=4, y=1},
	config = {
		extra = {
			least = 1
		}
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
		return {vars = {card.ability.extra.least}}
	end,
	calculate = function(self, card, context)
		if card.ability.immutable._active then
			if context.before and G.GAME.current_round.hands_played == 0 and #context.full_hand > card.ability.extra.least then
				context.full_hand[#context.full_hand]:set_edition("e_polychrome")
			end
		end
	end
}

SMODS.Consumable{
	set = "Voicebank",
	key = "vb_defoko",
	atlas = "voicebanks",
	pos = {x=0,y=2},
	calculate = function(self, card, context)
		if card.ability.immutable._active then
			if context.setting_blind and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
				local key = pseudorandom_element(SMODS.ConsumableTypes, "defoko_choice")
				if key then
					if key.default then
						key = key.default
					elseif key.key == "Planet" then
						key = "c_pluto"
					elseif key.key == "Spectral" then
						key = "c_incantation"
					elseif key.key == "Tarot" then
						key = "c_strength"
					else
						key = G.P_CENTER_POOLS[key.key][1].key -- unknown default, grab the first item of its type created
					end
					G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
					G.E_MANAGER:add_event(Event({
						func = function()
							G.E_MANAGER:add_event(Event({
								func = function()
									SMODS.add_card{key=key}
									G.GAME.consumeable_buffer = 0
									return true
								end
							}))
							SMODS.calculate_effect({ message = "+1", colour = G.C.PURPLE }, context.blueprint_card or card)
							return true
						end
					}))
					return nil, true -- This is for Joker retrigger purposes
				end
			end
		end
	end
}

SMODS.Consumable{
	set = "Voicebank",
	key = "vb_rei",
	atlas = "voicebanks",
	pos = {x=1,y=2},
	config = {
		extra = {
			chips_gain = 30
		},
		immutable = {
			suit = "Diamonds"
		}
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.immutable.suit, card.ability.extra.chips_gain}}
	end,
	calculate = function(self, card, context)
		if card.ability.immutable._active then
			if context.before then
				for _, _card in ipairs(context.scoring_hand) do
					if _card:is_suit(card.ability.immutable.suit) then
						SMODS.scale_card(_card, {
							ref_table = _card.ability,
							ref_value = "perma_bonus",
							scalar_table = card.ability.extra,
							scalar_value = "chips_gain"
						})
					end
				end
			end
		end
	end
}

SMODS.Consumable{
	set = "Voicebank",
	key = "vb_yuki",
	atlas = "voicebanks",
	pos = {x=2,y=2},
	config = {
		extra = {
			rank_decrease = 1
		},
		immutable = {
			suit = "Spades"
		}
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.immutable.suit, card.ability.extra.rank_decrease}}
	end,
	calculate = function (self, card, context)
		if card.ability.immutable._active then
			if context.before then
				for i, _card in ipairs(context.scoring_hand) do
					if _card:is_suit(card.ability.immutable.suit) then
						local percent = 1.15 - (i - 0.999) / (#context.scoring_hand - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.15,
							func = function()
								context.scoring_hand[i]:flip()
								play_sound('card1', percent)
								context.scoring_hand[i]:juice_up(0.3, 0.3)
								return true
							end
            }))
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							func = function()
								-- SMODS.modify_rank will increment/decrement a given card's rank by a given amount
								assert(SMODS.modify_rank(context.scoring_hand[i], -card.ability.extra.rank_decrease))
								return true
							end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.35,
                func = function()
                    context.scoring_hand[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    context.scoring_hand[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
						SMODS.scale_card(_card, {
							ref_table = _card.ability,
							ref_value = "perma_mult",
							scalar_table = {val = _card:get_id()},
							scalar_value = "val"
						})
					end
				end
			end
		end
	end
}

SMODS.Consumable{
	key = "vb_kafu",
	set = "Voicebank",
	atlas = "voicebanks",
	pos = {x=3,y=2},
	calculate = function (self, card, context)
		if card.ability.immutable._active then
			if context.destroy_card then
				if (context.cardarea == G.play or context.cardarea == "unscored") and G.GAME.current_round.hands_played == 0 then
					return {
						remove = true
					}
				end
			end
		end
	end
}

SMODS.Consumable{
	key = "vb_flower",
	set = "Voicebank",
	atlas = "voicebanks",
	pos = {x=4,y=2},
	config = {
		extra = {
			xmult_gain = 0.1
		}
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.xmult_gain}}
	end,
	calculate = function(self, card, context)
		if card.ability.immutable._active then
			if context.before then
				local suits = {
					['Hearts'] = 0,
					['Diamonds'] = 0,
					['Spades'] = 0,
					['Clubs'] = 0
				}
				for i = 1, #context.scoring_hand do
					if not SMODS.has_any_suit(context.scoring_hand[i]) then
						if context.scoring_hand[i]:is_suit('Hearts', true) and suits["Hearts"] == 0 then
							suits["Hearts"] = suits["Hearts"] + 1
						elseif context.scoring_hand[i]:is_suit('Diamonds', true) and suits["Diamonds"] == 0 then
							suits["Diamonds"] = suits["Diamonds"] + 1
						elseif context.scoring_hand[i]:is_suit('Spades', true) and suits["Spades"] == 0 then
							suits["Spades"] = suits["Spades"] + 1
						elseif context.scoring_hand[i]:is_suit('Clubs', true) and suits["Clubs"] == 0 then
							suits["Clubs"] = suits["Clubs"] + 1
						end
					end
				end
				for i = 1, #context.scoring_hand do
					if SMODS.has_any_suit(context.scoring_hand[i]) then
						if context.scoring_hand[i]:is_suit('Hearts') and suits["Hearts"] == 0 then
							suits["Hearts"] = suits["Hearts"] + 1
						elseif context.scoring_hand[i]:is_suit('Diamonds') and suits["Diamonds"] == 0 then
							suits["Diamonds"] = suits["Diamonds"] + 1
						elseif context.scoring_hand[i]:is_suit('Spades') and suits["Spades"] == 0 then
							suits["Spades"] = suits["Spades"] + 1
						elseif context.scoring_hand[i]:is_suit('Clubs') and suits["Clubs"] == 0 then
							suits["Clubs"] = suits["Clubs"] + 1
						end
					end
				end
				if suits["Hearts"] > 0 and
					suits["Diamonds"] > 0 and
					suits["Spades"] > 0 and
					suits["Clubs"] > 0 then
					for _, _card in ipairs(G.hand.cards) do
						SMODS.scale_card(_card, {
							ref_table = _card.ability,
							ref_value = "perma_x_mult",
							scalar_table = card.ability.extra,
							scalar_value = "xmult_gain"
						})
					end
				end
			end
		end
	end
}

SMODS.Consumable{
	key = "vb_zundamon",
	set = "Voicebank",
	atlas = "voicebanks",
	pos = {x=0,y=3},
	config = {
		extra = {
			poker_hand = "High Card"
		}
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.poker_hand}}
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and context.main_eval then
			local _poker_hands = {}
			for handname, _ in pairs(G.GAME.hands) do
				if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand then
					_poker_hands[#_poker_hands + 1] = handname
				end
			end
			card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'zundamon_choice')
			if card.ability.immutable._active then
				return {
					message = localize('k_reset')
				}
			end
		end
		if card.ability.immutable._active then
			if context.repetition then
				if context.scoring_name == card.ability.extra.poker_hand then
					return {
						repetitions = 1
					}
				end
			end
		end
	end
}

SMODS.Consumable{
	key = "vb_gumi",
	set = "Voicebank",
	atlas = "voicebanks",
	pos = {x=1, y=3},
	config = {
		extra = {
			num = 1,
			dem = 2
		},
		immutable = {
			rank1 = 13,
			rank2 = 12,
			counter = 0
		}
	},
	loc_vars = function(self, info_queue, card)
		local num, dem = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.dem, "gumi_retrigger")
		local ret = {vars = {num, dem}}
		if FooBar.average_probability() then ret.key = self.key .. "_simplex" end
		return ret
	end,
	calculate = function(self, card, context)
		if card.ability.immutable._active then
			if context.repetition then
				if context.other_card:get_id() == card.ability.immutable.rank1 or context.other_card:get_id() == card.ability.immutable.rank2 then
					local flag = false
					if FooBar.average_probability() then
						local num, dem = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.dem, "gumi_retrigger")
						card.ability.immutable.counter = (card.ability.immutable.counter + 1) % dem
						flag = card.ability.immutable.counter < num
					else
						flag = SMODS.pseudorandom_probability(card, "gumi_retrigger", card.ability.extra.num, card.ability.extra.dem)
					end
					return {
						repetitions = flag and 2 or 1
					}
				end
			end
		end
	end
}