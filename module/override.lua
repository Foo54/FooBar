---@diagnostic disable: duplicate-set-field, undefined-field
local card_set_cost_ref = Card.set_cost
function Card:set_cost()
	if self.config.center.key == "j_foobar_graphicscard" then
		if self.area ~= G.jokers then
			self.base_cost = 4 * (2 ^ (G.GAME.foobar_inflation or 0))
		end
	end
	card_set_cost_ref(self)
end

local card_click_ref = Card.click
function Card:click()
	card_click_ref(self)
	if not self.greyed then
		if self.foobar_reference then
			local j = SMODS.find_card("j_foobar_whiplash")[1]
			if j then
				if j.ability.immutable.active then
					draw_card(G.deck, G.hand, 100/#G.hand.cards,'up', nil, self.foobar_reference,  0.08)
					j.ability.immutable.active = false
				end
			end
		end
	end
end