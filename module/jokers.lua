SMODS.Joker = {
	key = "welcomenewmember",
	atlas = "jokers",
	cost = 5,
	config = {
		extra = {
			scaling = 5
		}
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.scaling, G.GAME.starting_deck_size, card.ability.extra.scaling * math.max(0, (G.playing_cards and (G.GAME.starting_deck_size - #G.playing_cards) or 0))}}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				card = card,
				chips = card.ability.extra.scaling * math.max(0, (G.playing_cards and (G.GAME.starting_deck_size - #G.playing_cards) or 0))
			}
		end
	end
}