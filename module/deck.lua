SMODS.Back({
	key = "bargain",
	config = {no_interest = true},
	atlas = "decks",
	pos = { x = 0, y = 0 },
	loc_vars = function(self, info_queue, card)
		return {vars = {1}}
	end,
	apply = function(self)
		G.GAME.modifiers.no_blind_reward = G.GAME.modifiers.no_blind_reward or {}
		G.GAME.modifiers.no_blind_reward.Small = true
		G.GAME.modifiers.no_blind_reward.Big = true
		G.GAME.modifiers.no_blind_reward.Boss = true
		G.GAME.backup_discount_percent = G.GAME.backup_discount_percent or G.GAME.discount_percent
		G.GAME.discount_percent = 100
	end
})

