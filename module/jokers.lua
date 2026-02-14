--- Contains all mod jokers

if false then
--- Ena Shinonome
SMODS.Joker{
	key = "enashinonome",
	atlas = "jokers",
	pos = {x=10,y=0},
	cost = 7,
	config = {
		extra = {
			mult = 0.25
		}
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.mult, 1 + card.ability.extra.mult * math.max(0, (G.hand.config.card_limit or 8) - (G.GAME.starting_params.hand_size or 8))}}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = 1 + card.ability.extra.mult * math.max(0, (G.hand.config.card_limit or 8) - (G.GAME.starting_params.hand_size or 8))
			}
		end
	end
}

--- Kanade Yoisaki
SMODS.Joker{
	key = "kanadeyoisaki",
	atlas = "jokers",
	pos = {x=8,y=0},
	cost = 4,
	config = {
		extra = {
			inc = 25,
			chips = 0
		},
		immutable = {
			safe = false
		}
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.inc, card.ability.extra.chips}}
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
			SMODS.scale_card(card, {
				ref_table = card.ability.extra,
				ref_value = "chips",
				scalar_value = "inc"
			})
		end
		if context.buying_card and not context.buying_self and not context.blueprint then
			if context.card.ability.set == "Joker" then
				card.ability.immutable.safe = true
			end
		end
		if context.starting_shop and not context.blueprint then
			card.ability.immutable.safe = false
		end
		if context.ending_shop and not context.blueprint then
			if not card.ability.immutable.safe then
				card.ability.extra.chips = 0
				return {
					message = "Must keep composing..."
				}
			end
		end
		if context.joker_main then
			return {
				chips = card.ability.extra.chips
			}
		end
	end
}
end

--- Nothing
SMODS.Joker{
	key = "nothing",
	atlas = "jokers",
	pos = {x=7,y=0},
	cost = 7,
	rarity = 2,
	config = {
		extra = {
			inc = 0.2,
			mult = 1
		}
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.inc, card.ability.extra.mult}}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = card.ability.extra.mult
			}
		end
		if context.joker_type_destroyed and not context.blueprint then
			SMODS.scale_card(card, {
				ref_table = card.ability.extra,
				ref_value = "mult",
				scalar_value = "inc"
			})
		end
		if context.remove_playing_cards and not context.blueprint then
			for i = 1, #context.removed do
				SMODS.scale_card(card, {
					ref_table = card.ability.extra,
					ref_value = "mult",
					scalar_value = "inc"
				})
			end
		end
	end
			
}

--- Lost Media
SMODS.Joker{
	key = "lostmedia",
	atlas = "jokers",
	pos = {x=6,y=0},
	rarity = 2,
	cost = 6,
	pools = {["Song"] = true, ["MonochroMenace"] = true},
	config = {
		extra = {
			inc = 1
		}
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
		return {vars = {card.ability.extra.inc}}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card then
			if SMODS.has_enhancement(context.other_card, "m_glass") then
				SMODS.scale_card(context.other_card, {
					ref_table = context.other_card.ability,
					ref_value = "foobar_numerator",
					scalar_table = card.ability.extra,
					scalar_value = "inc",
					no_message = true,
					operation = function(ref_table, ref_value, initial, change)
						ref_table[ref_value] = (initial or 1) + change
					end
				})
				SMODS.scale_card(context.other_card, {
					ref_table = context.other_card.ability,
					ref_value = "Xmult",
					scalar_table = card.ability.extra,
					scalar_value = "inc",
					scaling_message = {
						message = "Tap the glass..."
					}
				})
				SMODS.scale_card(context.other_card, {
					ref_table = context.other_card.ability,
					ref_value = "extra",
					scalar_table = card.ability.extra,
					scalar_value = "inc",
					no_message = true
				})
			end
		end
	end
}

--- FL Studio
SMODS.Joker{
	key = "flstudio",
	atlas = "jokers",
	pos = {x=4,y=0},
	soul_pos = {x=5,y=0},
	rarity = 4,
	cost = 20,
	config = {
		extra = {
			mult_scale = 2,
			money_scale = 5
		}
	},
	loc_vars = function(self, info_queue, card)
		local producers = FooBar.filter_by_pool(((G or {}).jokers or {}).cards or {}, "Producer")
		local songs = FooBar.filter_by_pool(((G or {}).jokers or {}).cards or {}, "Song")
		return {vars = {
			card.ability.extra.mult_scale,
			math.max(card.ability.extra.mult_scale * #producers, 1),
			card.ability.extra.money_scale,
			card.ability.extra.money_scale * #songs
		}}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			local producers = FooBar.filter_by_pool(G.jokers.cards or {}, "Producer")
			return {
				xmult = math.max(card.ability.extra.mult_scale * #producers, 1)
			}
		end
		if context.end_of_round and not context.individual and not context.blueprint then
			local songs = FooBar.filter_by_pool(G.jokers.cards or {}, "Song")
			return {
				dollars = card.ability.extra.money_scale * #songs
			}
		end
	end
}

--- Firestarter
SMODS.Joker{
	key = "firestarter",
	atlas = "jokers",
	pos = {x=3,y=0},
	rarity = 3,
	cost = 8,
	config = {
		extra = {
			mult = 10,
			timer = 3
		}
	},
	pools = {["Tanger"] = true, ["Song"] = true},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.mult, card.ability.extra.timer}}
	end,
	eternal_compat = false,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = card.ability.extra.mult
			}
		end
		if context.final_scoring_step and G.GAME.blind and SMODS.last_hand_oneshot then
			card.ability.extra.timer = card.ability.extra.timer - 1
			if card.ability.extra.timer <= 0 then
				return {
					message = "Burnt!",
					func = function()
						G.E_MANAGER:add_event(Event({
							func = function()
								SMODS.destroy_cards(card, nil, nil, nil)
								return true
							end
						}))
					end
				}
			else
				return {
					message = "Burning!"
				}
			end
		end
	end
}

--- Menace
SMODS.Joker{
	key = "menace",
	atlas = "jokers",
	pos = {x=2,y=0},
	rarity = 3,
	cost = 10,
	pools = {["Producer"] = true, ["MonochroMenace"] = true},
	loc_vars = function(self, info_queue, card)
		for i, seal in ipairs({"Purple", "Gold", "Blue", "Red"}) do
			info_queue[#info_queue + 1] = G.P_SEALS[seal]
		end
		return {vars = {}}
	end
}

--- Cannibalism
SMODS.Joker{
	key = "cannibalism",
	atlas = "jokers",
	pos = {x = 1, y = 0},
	cost = 6,
	rarity = 2,
	config = {
		extra = {
			scaling = 5,
			mult = 0
		}
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.scaling, card.ability.extra.mult}}
	end,
	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			local faces = false
			for _, playing_card in ipairs(context.scoring_hand) do
				if playing_card:is_face() then
					faces = true
					break
				end
			end
			if not faces then
				if card.ability.extra.mult > 0 then
					SMODS.scale_card(card, {
						ref_table = card.ability.extra,
						ref_value = "mult",
						scalar_value = "scaling",
						operation = "-",
						scaling_message = {
							message = "Starving!"
						}
					})
				end
			end
		end
		if context.joker_main then
			return {
				mult = card.ability.extra.mult
			}
		end
		if context.destroy_card and context.cardarea == G.play then
			if context.destroy_card:is_face() then
				return {
					message = "Eaten!",
					remove = true,
					func = function()
						G.E_MANAGER:add_event(Event({
							func = function()
								SMODS.scale_card(card, {
									no_message = true,
									ref_table = card.ability.extra,
									ref_value = "mult",
									scalar_value = "scaling"
								})
								return true
							end
						}))
					end
				}
			end
		end
	end
}

--- welcome new member
SMODS.Joker{
	key = "welcomenewmember",
	atlas = "jokers",
	cost = 9,
	rarity = 3,
	config = {
		extra = {
			scaling = 67
		}
	},
	pos = {x = 0, y = 0},
	pools = {["Glat"] = true, ["Discord"] = true},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.scaling, G.GAME.starting_deck_size, card.ability.extra.scaling * math.max(0, (G.playing_cards and (#G.playing_cards - G.GAME.starting_deck_size) or 0))}}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.extra.scaling * math.max(0, (G.playing_cards and (#G.playing_cards - G.GAME.starting_deck_size) or 0))
			}
		end
	end
}

