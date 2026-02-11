--- Contains all mod jokers

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
			mult_scale = 1,
			base_mult = 1,
			money_scale = 5,
			base_money = 0
		}
	},
	loc_vars = function(self, info_queue, card)
		local producers = FooBar.filter_by_pool(((G or {}).jokers or {}).cards or {}, "Producer")
		local songs = FooBar.filter_by_pool(((G or {}).jokers or {}).cards or {}, "Song")
		return {vars = {
			card.ability.extra.mult_scale,
			card.ability.extra.mult_scale * #producers + card.ability.extra.base_mult,
			card.ability.extra.money_scale,
			card.ability.extra.money_scale * #songs + card.ability.extra.base_money
		}}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			local producers = FooBar.filter_by_pool(G.jokers.cards or {}, "Producer")
			return {
				card = card,
				xmult = card.ability.extra.mult_scale * #producers + card.ability.extra.base_mult
			}
		end
		if context.end_of_round and not context.individual and not context.blueprint then
			local songs = FooBar.filter_by_pool(G.jokers.cards or {}, "Song")
			return {
				card = card,
				dollars = card.ability.extra.money_scale * #songs + card.ability.extra.base_money
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
				card = card,
				mult = card.ability.extra.mult
			}
		end
		if context.after and not context.blueprint and not context.retrigger_joker then
			if G.GAME.chips > G.GAME.blind.chips then
				card.ability.extra.timer = card.ability.extra.timer - 1
				if card.ability.extra.timer <= 0 then
					return {
						card = card,
						message = "Burnt!",
						func = function()
							G.E_MANAGER:add_event(Event({
								func = function()
									SMODS.destroy_card(card, nil, nil, nil)
								end
							}))
						end
					}
				else
					return {
						card = card,
						message = "Burning!"
					}
				end
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
				card = card,
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
				card = card,
				chips = card.ability.extra.scaling * math.max(0, (G.playing_cards and (#G.playing_cards - G.GAME.starting_deck_size) or 0))
			}
		end
	end
}

