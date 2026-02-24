
SMODS.Consumable{
	set = "Spectral",
	atlas = "spectrals",
	key = "sudormrf",
	pos = {x=0, y=0},
	can_use = function(self, card)
		return G.deck and G.deck.cards and #G.deck.cards > 0
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
		for index, value in ipairs(G.deck.cards) do
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.1,
				func = function()
					pcall(SMODS.destroy_cards, value, nil, nil, nil)
					return true
				end
			}))
		end
		local C = pseudorandom_element(G.hand.cards, "sudormrfcard")
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.1,
			func = function()
				pcall(SMODS.destroy_cards, C, nil, nil, nil)
				return true
			end
		}))
		local J = pseudorandom_element(G.jokers.cards, "sudormrfjoker")
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.1,
			func = function()
				pcall(SMODS.destroy_cards, J, nil, nil, nil)
				return true
			end
		}))

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
