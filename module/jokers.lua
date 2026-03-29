--- Contains all mod jokers

--- Page One

--- Hatsune Miku
SMODS.Joker{
	key = "hatsunemikun25",
	atlas = "jokers",
	pos = {x=12, y=0},
	pools = {["N25"] = true},
	rarity = 3,
	cost = 8,
	blueprint_compat = false,
	in_pool = function(self, args)
		for i, card in ipairs(G.jokers.cards) do
			if FooBar.safe_get(card.config.center, "pools", "N25") then return true end
		end
		return false
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				colours = {
					FooBar.badge_data.N25.color
				}
			}
		}
	end
}

--- Mizuki Akiyama
SMODS.Joker{
	key = "mizukiakiyama",
	atlas = "jokers",
	pos = {x=11, y=0},
	pools = {["N25"] = true},
	config = {
		extra = {
			scale = 0.25,
			mult = 1
		}
	},
	rarity = 2,
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return {
			key = next(SMODS.find_card("j_foobar_hatsunemikun25")) and "j_foobar_mizukiakiyama_miku" or nil,
			vars = {card.ability.extra.scale, card.ability.extra.mult}
		}
	end,
	calculate = function(self, card, context)
		if context.setting_ability and not context.blueprint then
			if ((context.new ~= "c_base" and context.old ~= "c_base") or next(SMODS.find_card("j_foobar_hatsunemikun25"))) and not context.unchanged then
				SMODS.scale_card(card, {
					ref_table = card.ability.extra,
					ref_value = "mult",
					scalar_value = "scale"
				})
			end
		end
		if context.joker_main then
			return {
				Xmult = card.ability.extra.mult
			}
		end
	end,
	joker_display_def = function(JokerDisplay)
		---@type JDJokerDefinition
		return {
			text = {
				{
					border_nodes = {
						{text = "X"},
						{ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "exp"}
					}
				}
			}
		}
	end
}

--- Ena Shinonome
SMODS.Joker{
	key = "enashinonome",
	atlas = "jokers",
	pos = {x=9,y=0},
	cost = 7,
	pools = {["N25"] = true},
	config = {
		extra = {
			numerator = 2,
			denominator = 5
		},
		immutable = {
			count = 0
		}
	},
	loc_vars = function(self, info_queue, card)
		local num, dem = SMODS.get_probability_vars(card, card.ability.extra.numerator, card.ability.extra.denominator, "foobar_ena")
		local ret = {key = "j_foobar_enashinonome", vars = {num, dem, card.ability.immutable.count + 1}}
		if FooBar.average_probability() then
			ret.key = ret.key .. "_simplex"
		end
		if next(SMODS.find_card("j_foobar_hatsunemikun25")) then
			ret.key = ret.key .. "_miku"
		end
		return ret
	end,
	calculate = function(self, card, context)
		if context.reroll_shop and (#G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit or next(SMODS.find_card("j_foobar_hatsunemikun25"))) then
			local flag = false
			if FooBar.average_probability() then
				local num, dem = SMODS.get_probability_vars(card, card.ability.extra.numerator, card.ability.extra.denominator, "foobar_ena")
				card.ability.immutable.count = (card.ability.immutable.count + 1) % dem
				flag = card.ability.immutable.count < num
			else
				flag = SMODS.pseudorandom_probability(card, "foobar_ena", card.ability.extra.numerator, card.ability.extra.denominator)
			end
			if flag then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					trigger = 'before',
					func = (function()
						SMODS.add_card {
							set = 'Tarot',
							key_append = 'foobar_ena'
						}
						G.GAME.consumeable_buffer = 0
						return true
					end)
				}))
				return {
					message = localize('k_plus_tarot'),
					colour = G.C.PURPLE,
				}
			end
		end
	end
}

--- Mafuyu Asahina
SMODS.Joker{
	key = "mafuyuasahina",
	atlas = "jokers",
	pos = {x=8,y=0},
	pools = {["N25"] = true},
	config = {
		extra = {
			chips = 25,
			loss = 1
		}
	},
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return {
			key = next(SMODS.find_card("j_foobar_hatsunemikun25")) and "j_foobar_mafuyuasahina_miku" or nil,
			vars = {card.ability.extra.chips, card.ability.extra.loss}
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if not next(SMODS.find_card("j_foobar_hatsunemikun25")) then
				context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) - card.ability.extra.loss
			end
			return {
				chips = card.ability.extra.chips
			}
		end
		if context.destroy_card and not context.blueprint then
			if context.destroying_card and (context.destroying_card.ability.perma_bonus or 0) + context.destroying_card.base.nominal <= 0 then
				return {
					remove = true
				}
			end
		end
	end,
	joker_display_def = function(JokerDisplay)
		---@type JDJokerDefinition
		return {
			text = {
				{text = "+"},
				{ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult"}
			},
			text_config = {colour = G.C.CHIPS},
			calc_function = function (card)
				local chips = 0
				local text, _, scoring_hand = JokerDisplay.evaluate_hand()
				if text ~= 'Unknown' then
					for _, scoring_card in pairs(scoring_hand) do
						chips = chips + card.ability.extra.chips * JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
					end
				end
				card.joker_display_values.chips = chips
			end
		}
	end
}

--- Kanade Yoisaki
SMODS.Joker{
	key = "kanadeyoisaki",
	atlas = "jokers",
	pos = {x=10,y=0},
	pools = {["N25"] = true},
	cost = 6,
	rarity = 2,
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
		return {
			key = next(SMODS.find_card("j_foobar_hatsunemikun25")) and "j_foobar_kanadeyoisaki_miku" or nil,
			vars = {card.ability.extra.inc, card.ability.extra.chips}
		}
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
		if context.ending_shop and not context.blueprint and not next(SMODS.find_card("j_foobar_hatsunemikun25")) then
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
	end,
	joker_display_def = function(JokerDisplay)
		---@type JDJokerDefinition
		return {
			text = {
				{text = "+"},
				{ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult"},
				{ref_table = "card.joker_display_values", ref_value = "arrow", colour = G.C.UI.TEXT_LIGHT},
				{ref_table = "card.joker_display_values", ref_value = "new_chips"}
			},
			text_config = {colour = G.C.CHIPS},
			calc_function = function (card)
				card.joker_display_values.arrow = ""
				card.joker_display_values.new_chips = ""
				card.joker_display_values.chips = card.ability.extra.chips
				if G.STATE == G.STATES.SHOP then
					if not card.ability.immutable.safe then
						card.joker_display_values.arrow = " -> "
						card.joker_display_values.new_chips = "+0"
					end
				end
				if G.STATE == G.STATES.BLIND_SELECT then
					card.joker_display_values.arrow = " -> "
					card.joker_display_values.new_chips = "+" .. (card.ability.extra.chips + card.ability.extra.inc)
				end
			end
		}
	end
}

--- Fryer
SMODS.Joker{
	key = "fryer",
	atlas = "jokers",
	pos = {x=2,y=1},
	config = {
		extra = {
			money = 1
		}
	},
	rarity = 2,
	cost = 6,
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.money}}
	end,
	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			if #G.hand.cards > 0 then
				SMODS.destroy_cards(G.hand.cards[#G.hand.cards], nil, nil, nil)
				return {
					dollars = card.ability.extra.money
				}
			end
		end
	end,
	joker_display_def = function(JokerDisplay)
		---@type JDJokerDefinition
		return {
			text = {
				{ text = "+$"},
				{ ref_table = "card.joker_display_values", ref_value = "dollars", retrigger_type = "mult" },
			},
			text_config = {colour = G.C.MONEY},
			calc_function = function (card)
				card.joker_display_values.dollars = 0
				if G.GAME.blind and G.GAME.blind.in_blind then
					if G.hand then
						if #G.hand.cards - #G.hand.highlighted > 0 then
							card.joker_display_values.dollars = card.ability.extra.money
						end
					end
				end
			end
		}
	end
}

--- Simplex
SMODS.Joker{
	key = "simplex",
	atlas = "jokers",
	pos = {x=0,y=1},
	rarity = 2,
	cost = 8,
	blueprint_compat = false
}

--- Graphics Card
SMODS.Joker{
	key = "graphicscard",
	atlas = "jokers",
	pos = {x=1, y=1},
	config = {
		extra = {
			scale = 2
		}
	},
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.scale, card.sell_cost * card.ability.extra.scale}}
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			G.GAME.foobar_inflation = (G.GAME.foobar_inflation or 0) + 1
		end
		if context.joker_main then
			return {
				mult = card.sell_cost * card.ability.extra.scale
			}
		end
	end,
	joker_display_def = function(JokerDisplay)
		---@type JDJokerDefinition
		return {
			text = {
				{text = "+"},
				{ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult"}
			},
			text_config = {G.C.MULT},
			calc_function = function (card)
				card.joker_display_values.mult = card.sell_cost * card.ability.extra.scale
			end
		}
	end
}

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
	end,
	joker_display_def = function(JokerDisplay)
		---@type JDJokerDefinition
		return {
			text = {
				{
					border_nodes = {
						{text = "X"},
						{ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "exp"}
					}
				}
			}
		}
	end
}

--- Lost Media
SMODS.Joker{
	key = "lostmedia",
	atlas = "jokers",
	pos = {x=6,y=0},
	rarity = 2,
	cost = 6,
	pools = {["Song"] = true},
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
					ref_value = "x_mult",
					scalar_table = card.ability.extra,
					scalar_value = "inc",
					no_message = true
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
	end,
	joker_display_def = function(JokerDisplay)
		---@type JDJokerDefinition
		return {
			text = {
				{
					border_nodes = {
						{text = "X"},
						{ref_table = "card.joker_display_values", ref_value = "clout", retrigger_type = "exp"}
					}
				},
				{text = ", "},
				{text = "+$", colour = G.C.MONEY},
				{ref_table = "card.joker_display_values", ref_value = "ad_revenue", retrigger_type = "mult", colour = G.C.MONEY}
			},
			reminder_text = {
				{text = "(Hand, Round)"}
			},
			calc_function = function (card)
				local producers = FooBar.filter_by_pool(G.jokers.cards or {}, "Producer")
				local songs = FooBar.filter_by_pool(G.jokers.cards or {}, "Song")
				card.joker_display_values.clout = #producers * card.ability.extra.mult_scale
				card.joker_display_values.ad_revenue = #songs * card.ability.extra.money_scale
			end
		}
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
	pools = {["Song"] = true},
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
		if context.final_scoring_step and G.GAME.blind and SMODS.last_hand_oneshot and not context.blueprint then
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
	end,
	joker_display_def = function(JokerDisplay)
		---@type JDJokerDefinition
		return {
			text = {
				{
					border_nodes = {
						{text = "X"},
						{ref_table = "card.ability.extra", ref_value = "mult", retrigger_type="exp"}
					}
				}
			}
		}
	end
}

--- Menace
SMODS.Joker{
	key = "menace",
	atlas = "jokers",
	pos = {x=2,y=0},
	rarity = 3,
	cost = 10,
	pools = {["Producer"] = true},
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
	end,
	joker_display_def = function(JokerDisplay)
		---@type JDJokerDefinition
		return {
			text = {
				{text = "+"},
				{ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult"}
			},

			text_config = {colour = G.C.MULT},
			calc_function = function (card)
				card.joker_display_values.mult = card.ability.extra.mult
				local text, _, scoring_hand = JokerDisplay.evaluate_hand()
				if text ~= "Unknown" then
					local faces = false
					for _, playing_card in ipairs(scoring_hand) do
						if playing_card:is_face() then
							faces = true
							break
						end
					end
					if not faces then
						card.joker_display_values.mult = math.max(0, card.ability.extra.mult - card.ability.extra.scaling)
					end
				end
			end
		}
	end
}

--- welcome new member
SMODS.Joker{
	key = "welcomenewmember",
	atlas = "jokers",
	cost = 9,
	config = {
		extra = {
			scaling = 6.7
		}
	},
	pos = {x = 0, y = 0},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.scaling, G.GAME.starting_deck_size, card.ability.extra.scaling * math.max(0, (G.playing_cards and (#G.playing_cards - G.GAME.starting_deck_size) or 0))}}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.extra.scaling * math.max(0, (G.playing_cards and (#G.playing_cards - G.GAME.starting_deck_size) or 0))
			}
		end
	end,
	joker_display_def = function(JokerDisplay)
		---@type JDJokerDefinition
		return {
			text = {
				{text = "+"},
				{ref_table = "card.joker_display_values", ref_value = "67", retrigger_type = "mult"}
			},
			text_config = {colour = G.C.CHIPS},
			calc_function = function (card)
				card.joker_display_values["67"] = card.ability.extra.scaling * math.max(0, (G.playing_cards and (#G.playing_cards - G.GAME.starting_deck_size) or 0))
			end
		}
	end
}

--- Page Two

--- baguette
SMODS.Joker{
	key = "baguette",
	atlas = "jokers",
	pos = {x=3, y=1},
	config = {
		extra = {
			money = 1
		},
		immutable = {
			rounds = 4
		}
	},
	cost = 4,
	eternal_compat = false,
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.money, card.ability.immutable.rounds}}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:is_face() then
				return {
					dollars = card.ability.extra.money
				}
			end
		end
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			card.ability.immutable.rounds = card.ability.immutable.rounds - 1
			if card.ability.immutable.rounds == 0 then
				SMODS.destroy_cards(card, nil, nil, nil)
				return {
					message = localize('k_eaten_ex'),
					colour = G.C.RED
				}
			else
				return {
					message = "nom!",
					colour = G.C.YELLOW,
					func = function(...)
						G.E_MANAGER:add_event(Event({
							func = function()
								self:set_sprites(card, card.config.center)
								return true
							end
						}))
					end
				}
			end
		end
	end,
	set_sprites = function(self, card, front)
		if card.ability and card.ability.immutable and card.ability.immutable.rounds > 0 then
			card.children.center:set_sprite_pos({x = 3 + 4 - card.ability.immutable.rounds, y = 1})
		end
	end,
	joker_display_def = function(JokerDisplay)
		---@type JDJokerDefinition
		return {
			text = {
				{text = "+$"},
				{ref_table = "card.joker_display_values", ref_value = "money", retrigger_type = "mult"}
			},
			reminder_text = {
				{text = "("},
				{text = "Face Cards", colour = G.C.ORANGE},
				{text = ")"}
			},
			text_config = {colour = G.C.MONEY},
			calc_function = function (card)
				local money = 0
				local text, _, scoring_hand = JokerDisplay.evaluate_hand()
				if text ~= 'Unknown' then
					for _, scoring_card in pairs(scoring_hand) do
						if scoring_card:is_face() then
							money = money + card.ability.extra.money * JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
						end
					end
				end
				card.joker_display_values.money = money
			end
		}
	end
}

--- nic
SMODS.Joker{
	key = "nic",
	atlas = "jokers",
	pos = {x=7,y=1},
	config = {
		extra = {
			money = 67
		}
	},
	cost = 25,
	rarity = 4,
	pools = {["nic"] = true, ["Producer"] = true},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.money}}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if G.GAME.dollars + (G.GAME.dollar_buffer or 0) == 67 then
				return {
---@diagnostic disable-next-line: undefined-field
					chips = G.GAME.blind.chips,
					message = "nic"
				}
			end
		end
	end,
	calc_dollar_bonus = function(self, card)
		return card.ability.extra.money
	end,
	joker_display_def = function(JokerDisplay)
		---@type JDJokerDefinition
		return {
			text = {
				{text = "nic"}
			}
		}
	end
}

--- Le fish au chocolat
SMODS.Joker{
	key = "lefisheauchocolat",
	atlas = "jokers",
	pos = {x=8,y=1},
	cost = 7,
	rarity = 2,
	config = {
		extra = {
			num = 1,
			dem = 7,
			mult = 7
		},
		immutable = {
			counter = 1
		}
	},
	loc_vars = function(self, info_queue, card)
		local key = self.key
		if FooBar.average_probability() then key = key .. "_simplex" end
		local num, dem = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.dem, "foobar_lefishauchocolat")
		return {key = key, vars = {num, dem, card.ability.extra.mult}}
	end,
	calculate = function(self, card, context)
		if context.stay_flipped and not context.blueprint then
			if context.from_area == G.deck and context.to_area == G.hand then
				local flag = false
				if FooBar.average_probability() then --- REALY LAGGY: FIX THIS
					local num, dem = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.dem, "foobar_lefishauchocolat")
					card.ability.immutable.count = (card.ability.immutable.count + 1) % dem
					flag = card.ability.immutable.count < num
				else
					flag = SMODS.pseudorandom_probability(card, "foobar_lefishauchocolat", card.ability.extra.num, card.ability.extra.dem)
				end
				if flag then
					return {
						stay_flipped = true
					}
				end
			end
			if context.from_area == G.hand and (context.to_area == G.play or context.to_area == "unscored") then
				return {
					stay_flipped = true
				}
			end
		end
		if context.individual and context.cardarea == G.play then
			if context.other_card.facing == "back" then
				return {
					mult = card.ability.extra.mult
				}
			end
		end
		if context.check_enhancement and context.other_card.cardarea ~= G.deck and not context.blueprint then
			if context.other_card.facing == "back" then
				return {
					m_wild = true
				}
			end
		end
	end,
	joker_display_def = function(JokerDisplay)
		---@type JDJokerDefinition
		return {
			text = {
				{text = "+"},
				{ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult"}
			},
			reminder_text = {
				{text = "(Face down)"}
			},
			text_config = {colour = G.C.MULT},
			calc_function = function (card)
				local mult = 0
				local text, _, scoring_hand = JokerDisplay.evaluate_hand()
				for _, scoring_card in pairs(scoring_hand) do
					if scoring_card.facing == "back" then
						mult = mult + card.ability.extra.mult * JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
					end
				end
				card.joker_display_values.mult = mult
			end
		}
	end
}

--- Adachi Rei
SMODS.Joker{
	key = "adachirei",
	atlas = "jokers",
	pos = {x=9,y=1},
	config = {
		extra = {
			cmult = 30,
			chips = 0
		}
	},
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return {
			main_start = {
				{ n = G.UIT.T, config = { text = ' +', colour = G.C.CHIPS, scale = 0.32 } },
				{
					n = G.UIT.O,
					config = {
						object = DynaText({
							string = {
								{prefix = "", ref_table = card.ability.extra, ref_value = "chips"}
							},
							colours = { G.C.CHIPS },
							bump = true,
							pop_in_rate = 999999,
							silent = true,
							pop_delay = 0.1,
							scale = 0.32,
							min_cycle_time = 0.1
						})
					}
				},
				{ n = G.UIT.T, config = { text = ' chips', colour = G.C.CHIPS, scale = 0.32 } },
			},
			vars = {card.ability.extra.cmult}
		}
	end,
	update = function(self, card, dt)
		card.ability.extra.chips = math.floor(card.ability.extra.cmult * math.sin(love.timer.getTime())) + card.ability.extra.cmult
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.extra.chips
			}
		end
	end,
	joker_display_def = function(JokerDisplay)
		---@type JDJokerDefinition
		return {
			text = {
				{text = "+"},
				{ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "mult"}
			},
			text_config = {colour = G.C.CHIPS}
		}
	end
}

--- Whiplash
SMODS.Joker{
	key = "whiplash",
	atlas = "jokers",
	pos = {x=10,y=1},
	config = {
		extra = {
			handsize_loss = 1
		},
		immutable = {
			active = false
		}
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.immutable.active and "Active" or "Inactive", -card.ability.extra.handsize_loss}}
	end,
	rarity = 2,
	cost = 7,
	add_to_deck = function(self, card, from_debuff)
			G.hand:change_size(-card.ability.extra.handsize_loss)
	end,
	remove_from_deck = function(self, card, from_debuff)
			G.hand:change_size(card.ability.extra.handsize_loss)
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
			card.ability.immutable.active = true
			juice_card_until(card, function() return not G.RESET_JIGGLES and card.ability.immutable.active end, true)
		end
	end
}

--- Mitosis
SMODS.Joker{
	key = "mitosis",
	atlas = "jokers",
	pos = {x=11,y=1},
	config = {
		immutable = {
			num = 1,
			dem = 2,
			state = true
		}
	},
	rarity = 3,
	cost = 9,
	loc_vars = function(self, info_queue, card)
		return {
			key = self.key .. (FooBar.average_probability() and "_simplex" or ""),
			vars = {card.ability.immutable.num, card.ability.immutable.dem}
		}
	end,
	blueprint_compat = false,
	calculate = function(self, card, context)
		if not context.blueprint and context.using_consumeable then
			local flag = false
			if FooBar.average_probability() then
---@diagnostic disable-next-line: cast-local-type
				flag = card.ability.immutable.state
				card.ability.immutable.state = not card.ability.immutable.state
			else
				flag = pseudorandom("mitosis_duplicate", 0, 1) < 0.5
			end
			if flag then
				G.E_MANAGER:add_event(Event({
					func = function()
						local copied_card = copy_card(context.consumeable, nil)
						copied_card:add_to_deck()
						G.consumeables:emplace(copied_card)
						return true
					end
				}))
				return {
					message = "Duplicated!"
				}
			end
			return {
				message = "Nope!"
			}
		end
	end
}

--- Cigarette
SMODS.Joker{
	key = "cigarette",
	atlas = "jokers",
	pos = {x=0, y=2},
	rarity=3,
	cost=6,
	config = {
		extra = {
			hand_size = 1,
			destroyed = 1
		}
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.hand_size, card.ability.extra.destroyed}}
	end,
	calculate = function(self, card, context)
		if context.last_hand_oneshot and context.main_eval and context.end_of_round then
			for i = 1, card.ability.extra.destroyed do
				local card = pseudorandom_element(G.deck.cards, "cigarette_lung_cancer")
				if card then
					SMODS.destroy_cards(card)
				end
			end
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		G.hand:change_size(-card.ability.extra.hand_size)
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.hand:change_size(card.ability.extra.hand_size)
	end
}

--- Kasane Teto
SMODS.Joker{
	key = "teto",
	atlas = "jokers",
	pos = {x=1, y=2},
	soul_pos = {x=2, y=2},
	rarity = 4,
	cost = 25,
	config = {
		extra = {
			chips = 3.1
		}
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.chips}}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:get_id() == 4 or context.other_card:get_id() == 14 then
				return {
					xchips = card.ability.extra.chips
				}
			end
		end
	end,
	joker_display_def = function(JokerDisplay)
		---@type JDJokerDefinition
		return {
			text = {
				{
					border_nodes = {
						{text = "X"},
						{ref_table = "card.joker_display_values", ref_value = "xchips", retrigger_type = "exp"}
					},
					border_colour = G.C.CHIPS
				}
			},
			reminder_text = {
				{text = "(4's and Aces)"}
			},
			calc_function = function (card)
				local xchips = 0
				local text, _, scoring_hand = JokerDisplay.evaluate_hand()
				if text ~= 'Unknown' then
					for _, scoring_card in pairs(scoring_hand) do
						if scoring_card:get_id() == 4 or scoring_card:get_id() == 14 then
							xchips = xchips * card.ability.extra.xchips ^ JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
						end
					end
				end
				card.joker_display_values.xchips = xchips
			end
		}
	end
}

--- Teto Pear
SMODS.Joker{
	key = "pearto",
	atlas = "jokers",
	pos = {x=3,y=2},
	rarity = 2,
	cost = 3,
	config = {
		extra = {
			num = 1,
			dem = 401,
			destroy = 31
		}
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.j_foobar_teto
		local num1, dem1 = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.dem, "pearto")
		local num2, dem2 = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.destroy, "pearto_consume")
		return {vars = {num1, dem1, num2, dem2}}
	end,
	calculate = function(self, context, card)
		if context.end_of_round and context.main_eval then
			if SMODS.pseudorandom_probability(card, "pearto", card.ability.extra.num, card.ability.extra.dem) then
				SMODS.add_card{key="j_foobar_teto"}
			end
			if SMODS.pseudorandom_probability(card, "perto_consume", card.ability.extra.num, card.ability.extra.destroy) then
				SMODS.destroy_cards(card)
			end
		end
	end
}

--- Companion Cube
SMODS.Joker{
	key = "companioncube",
	atlas = "jokers",
	pos = {x=4,y=2},
	rarity = 3,
	cost = 17,
	add_to_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit + 1
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit - 1
	end
}

--- Feedback
SMODS.Joker{
	key = "feedback",
	atlas = "jokers",
	pos = {x=5,y=2},
	cost = 5,
	config = {
		extra = {
			mult = 0,
			scaling = 3
		}
	},
	pools = {["Song"] = true},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.mult, card.ability.extra.scaling}}
	end,
	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			local scaled = true
			for key, value in ipairs(context.scoring_hand) do
				if value:get_id() == 14 and value.base.suit == "Spades" and SMODS.has_enhancement(value, "m_wild") then
					SMODS.scale_card(card, {
						ref_table = card.ability.extra,
						ref_value = "mult",
						scalar_value = "scaling"
					})
					break
				end
			end
		end
		if context.joker_main then
			return {
				mult = card.ability.extra.mult
			}
		end
	end,
	joker_display_def = function(JokerDisplay)
		---@type JDJokerDefinition
		return {
			text = {
				{text = "+"},
				{ref_table = "card.joker_display_values", ref_value = "mult"}
			},
			reminder_text = {
				{text = "(Wild Ace of Spades)"}
			},
			text_config = {colour = G.C.MULT},
			calc_function = function (card)
				local mult = card.ability.extra.mult
				local text, _, scoring_hand = JokerDisplay.evaluate_hand()
				if text ~= 'Unknown' then
					for _, scoring_card in pairs(scoring_hand) do
						if scoring_card:get_id() == 14 and scoring_card.base.suit == "Spades" and SMODS.has_enhancement(scoring_card, "m_wild") then
							mult = mult + card.ability.extra.scaling
						end
					end
				end
				card.joker_display_values.mult = mult
			end
		}
	end
}

--- HITO Mania
SMODS.Joker{
	key = "hitomania",
	atlas = "jokers",
	pos = {x=6,y=2},
	cost=5,
	config = {
		extra = {
			min_mult = 1,
			max_mult = 5,
			min_chips = 1,
			max_chips = 30
		}
	},
	pools = {["Song"] = true},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.min_mult, card.ability.extra.max_mult, card.ability.extra.min_chips, card.ability.extra.max_chips}}
	end,
	blueprint_compat = true,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:is_face() then
				local mult = pseudorandom("hito_mult", card.ability.extra.min_mult, card.ability.extra.max_mult)
				local chips = pseudorandom("hito_chips", card.ability.extra.min_chips, card.ability.extra.max_chips)
				if pseudorandom("hito_determine", 1, 2) == 1 then
					mult = 0
				else
					chips = 0
				end
				return {
					mult = mult,
					chips = chips
				}
			end
		end
	end,
	joker_display_def = function(JokerDisplay)
		---@type JDJokerDefinition
		return {
			text = {
				{text = "+", colour = G.C.CHIPS},
				{ref_table = "card.joker_display_values", ref_value = "min_chips", retrigger_type = "mult", colour = G.C.CHIPS},
				{text = " - ", colour = G.C.CHIPS},
				{ref_table = "card.joker_display_values", ref_value = "max_chips", retrigger_type = "mult", colour = G.C.CHIPS},
				{text = ", "},
				{text = "+", colour = G.C.MULT},
				{ref_table = "card.joker_display_values", ref_value = "min_mult", retrigger_type = "mult", colour = G.C.MULT},
				{text = " - ", colour = G.C.MULT},
				{ref_table = "card.joker_display_values", ref_value = "max_mult", retrigger_type = "mult", colour = G.C.MULT}
			},
			reminder_text = {
				{text = "("},
				{text = "Face Cards", colour = G.C.ORANGE},
				{text = ")"}
			},
			calc_function = function (card)
				local min_chips = 0
				local max_chips = 0
				local min_mult = 0
				local max_mult = 0
				local text, _, scoring_hand = JokerDisplay.evaluate_hand()
				if text ~= 'Unknown' then
					for _, scoring_card in pairs(scoring_hand) do
						if scoring_card:is_face() then
							local n = JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
							min_chips = min_chips + card.ability.extra.min_chips * n
							max_chips = max_chips + card.ability.extra.max_chips * n
							min_mult = min_mult + card.ability.extra.min_mult * n
							max_mult = max_mult + card.ability.extra.max_mult * n
						end
					end
				end
				card.joker_display_values.min_chips = min_chips
				card.joker_display_values.max_chips = max_chips
				card.joker_display_values.min_mult = min_mult
				card.joker_display_values.max_mult = max_mult
			end
		}
	end
}

--- Plagiarism
SMODS.Joker{
	key="plagiarism",
	atlas = "ai",
	pos = {x=0,y=0},
	cost=10,
	rarity=3,
	config = {
		immutable = {
			copies = 2,
			key1 = nil,
			key2 = nil
		}
	},
	blueprint_compat = false,
	loc_vars = function (self, info_queue, card)
		local card1 = "None"
		local card2 = "None"
		if card.ability.immutable.key1 then
			local _card = G.P_CENTERS[card.ability.immutable.key1]
			info_queue[#info_queue+1] = _card
			card1 = localize{type="name_text", set = "Joker", key= card.ability.immutable.key1} or ("ERROR: " .. _card.key)
		end
		if card.ability.immutable.key2 then
			local _card = G.P_CENTERS[card.ability.immutable.key2]
			info_queue[#info_queue+1] = _card
			card2 = localize{type="name_text", set = "Joker", key= card.ability.immutable.key2} or ("ERROR: " .. _card.key)
		end
		return {vars = {card.ability.immutable.copies, card1, card2}}
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
			local valid_jokers = {}
			for _, joker in ipairs(G.jokers.cards) do
				if joker.config.center.key ~= card.config.center.key and (not joker.edition or joker.edition.key ~= "e_negative") then
					table.insert(valid_jokers, joker.config.center.key)
				end
			end
			if #valid_jokers == 1 then
				card.ability.immutable.key1 = valid_jokers[1]
			elseif #valid_jokers > 0 then
				card.ability.immutable.key1 = pseudorandom_element(valid_jokers, "plagiarism_select_card_1")
				card.ability.immutable.key2 = pseudorandom_element(valid_jokers, "plagiarism_select_card_2")
			end
		end
		if card.ability.immutable.key1 and not context.blueprint then
			local first_done = false
			local second_done = false
			local ret = {}
			for _, joker in ipairs(G.jokers.cards) do
				if joker.config.center.key == card.ability.immutable.key1 and not first_done then
					ret = SMODS.merge_effects({ret, SMODS.blueprint_effect(card, joker, context)})
					first_done = true
				end
				if joker.config.center.key == card.ability.immutable.key2 and not second_done then
					ret = SMODS.merge_effects({ret, SMODS.blueprint_effect(card, joker, context)})
					second_done = true
				end
				if first_done and second_done then
					break
				end
			end
			if ret then ret.color = G.C.ORANGE end
			return ret
		end
	end,
	joker_display_def = function(JokerDisplay)
		---@type JDJokerDefinition
		return {
			text = {
				{ref_table = "card.joker_display_values", ref_value = "card1"},
			},
			reminder_text = {
				{ref_table = "card.joker_display_values", ref_value = "card2"}
			},
			text_config = {
				scale = 0.4
			},
			reminder_text_config = {
				scale = 0.4,
				colour = G.C.UI.TEXT_LIGHT
			},
			calc_function = function(card)
				local card1 = "None"
				local card2 = "None"
				if card.ability.immutable.key1 then
					card1 = localize{type="name_text", set = "Joker", key= card.ability.immutable.key1} or ("ERROR: " .. card.ability.immutable.key1)
				end
				if card.ability.immutable.key2 then
					card2 = localize{type="name_text", set = "Joker", key= card.ability.immutable.key2} or ("ERROR: " .. card.ability.immutable.key2)
				end
				card.joker_display_values.card1 = card1
				card.joker_display_values.card2 = card2
			end
		}
	end
}


