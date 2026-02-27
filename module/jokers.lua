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
		ret = {key = "j_foobar_enashinonome", vars = {num, dem, card.ability.immutable.count + 1}}
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
					chips = G.GAME.blind.chips,
					message = "nic"
				}
			end
		end
	end,
	calc_dollar_bonus = function(self, card)
		return card.ability.extra.money
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
		if context.check_enhancement and context.cardarea ~= G.deck and not context.blueprint then
			if context.other_card.facing == "back" then
				return {
					m_wild = true
				}
			end
		end
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
	end
}

--- Whiplash
SMODS.Joker{
	key = "whiplash",
	atlas = "jokers",
	pos = {x=10,y=1},
	config = {
		extra = {
			handsize_loss = 2
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




