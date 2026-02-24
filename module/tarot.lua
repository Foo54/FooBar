SMODS.Consumable{
	set = "Tarot",
	atlas = "tarots",
	key = "dingus",
	pos = {x=0, y=0},
	config = {
		max_highlighted = 5
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.max_highlighted}}
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		for i = 1, #G.hand.highlighted do
			local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					G.hand.highlighted[i]:flip()
					play_sound('card1', percent)
					G.hand.highlighted[i]:juice_up(0.3, 0.3)
					return true
				end
			}))
		end
		delay(0.2)
		for i = 1, #G.hand.highlighted do
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.1,
				func = function()
					assert(SMODS.change_base(G.hand.highlighted[i], pseudorandom_element(SMODS.Suits, pseudoseed("dingus_suit")).key, pseudorandom_element(SMODS.Ranks, pseudoseed("dingus_rank")).key))
					return true
				end
			}))
		end
		for i = 1, #G.hand.highlighted do
			local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					G.hand.highlighted[i]:flip()
					play_sound('tarot2', percent, 0.6)
					G.hand.highlighted[i]:juice_up(0.3, 0.3)
					return true
				end
			}))
		end
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.2,
			func = function()
				G.hand:unhighlight_all()
				return true
			end
		}))
		delay(0.5)
	end
}

SMODS.Consumable{
	set = "Tarot",
	atlas = "tarots",
	key = "robot",
	pos = {x=1, y=0},
	config = {
		max_highlighted = 1,
		immutable = {
			copies = 2
		}
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.max_highlighted, card.ability.immutable.copies}}
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		delay(0.2)
		for i = 1, #G.hand.highlighted do
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.1,
				func = function()
					local _first_dissolve = nil
					local new_cards = {}

					G.playing_card = (G.playing_card and G.playing_card + 1) or 1
					local _card1 = copy_card(G.hand.highlighted[i], nil, nil, G.playing_card)
					assert(SMODS.change_base(_card1, pseudorandom_element(SMODS.Suits, pseudoseed("robot_suit")).key))
					_card1:add_to_deck()
					G.deck.config.card_limit = G.deck.config.card_limit + 1
					table.insert(G.playing_cards, _card1)
					G.hand:emplace(_card1)
					_card1:start_materialize(nil, _first_dissolve)
					_first_dissolve = true
					new_cards[#new_cards + 1] = _card1

					G.playing_card = (G.playing_card and G.playing_card + 1) or 1
					local _card2 = copy_card(G.hand.highlighted[i], nil, nil, G.playing_card)
					assert(SMODS.change_base(_card2, nil, pseudorandom_element(SMODS.Ranks, pseudoseed("robot_rank")).key))
					_card2:add_to_deck()
					G.deck.config.card_limit = G.deck.config.card_limit + 1
					table.insert(G.playing_cards, _card2)
					G.hand:emplace(_card2)
					_card2:start_materialize(nil, _first_dissolve)
					_first_dissolve = true
					new_cards[#new_cards + 1] = _card2

					SMODS.calculate_context({ playing_card_added = true, cards = new_cards })
					
					return true
				end
			}))
		end
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.2,
			func = function()
				G.hand:unhighlight_all()
				return true
			end
		}))
		delay(0.5)
	end
}