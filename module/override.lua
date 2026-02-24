local card_set_cost_ref = Card.set_cost
function Card:set_cost()
	if self.config.center.key == "j_foobar_graphicscard" then
		if self.area ~= G.jokers then
			self.base_cost = 4 * (2 ^ (G.GAME.foobar_inflation or 0))
		end
	end
	card_set_cost_ref(self)
end