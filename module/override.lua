---@diagnostic disable: duplicate-set-field, undefined-field, lowercase-global
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

local blind_tag_ref = create_UIBox_blind_tag
function create_UIBox_blind_tag(blind_choice, run_info)
	local ret = blind_tag_ref(blind_choice, run_info)
	if not ret then return ret end
	if ret then return ret end -- temporary
  local _tag = Tag("tag_uncommon", nil, blind_choice)
  local _tag_ui, _tag_sprite = _tag:generate_UI()
  _tag_sprite.states.collide.can = not not run_info
	ret.nodes[#ret.nodes+1] = {
		n=G.UIT.R, config={id = 'minigame_'..blind_choice, align = "cm", r = 0.1, padding = 0.1, minw = 1, can_collide = true, ref_table = _tag_sprite}, nodes={
			{n=G.UIT.C, config={id = 'minigame_desc', align = "cm", minh = 1}, nodes={
				_tag_ui
			}},
			not run_info and {n=G.UIT.C, config={align = "cm", colour = G.C.UI.BACKGROUND_INACTIVE, minh = 0.6, minw = 2, maxw = 2, padding = 0.07, r = 0.1, shadow = true, hover = true, one_press = true, button = 'skip_blind', func = 'hover_tag_proxy', ref_table = _tag}, nodes={
				{n=G.UIT.T, config={text = "Play Minigame", scale = 0.4, colour = G.C.UI.TEXT_INACTIVE}}
			}} or {n=G.UIT.C, config={align = "cm", padding = 0.1, emboss = 0.05, colour = mix_colours(G.C.BLUE, G.C.BLACK, 0.4), r = 0.1, maxw = 2}, nodes={
				{n=G.UIT.T, config={text = "Play Minigame", scale = 0.35, colour = G.C.WHITE}},
			}},
		}
	}
	return ret
end