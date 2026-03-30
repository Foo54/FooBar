SMODS.Back({
	key = "custom",
	config = {},
	atlas = "decks",
	pos = {x = 0.5, y = 0},
	loc_vars = function(self, info_queue, card)
		return {main_end = {
			{n = G.UIT.R, config = {align = "cm", maxw = 1}, nodes = {
				{n = G.UIT.R, config = {align = "cm", padding=0.1, r=0.2, colour = G.C.BLUE, button = "foobar_open_edit_deck", func = "foobar_open_edit_deck_allow", shadow=true}, nodes = {
					{n = G.UIT.T, config = {text = "Edit Deck", scale = 0.3, colour = G.C.UI.TEXT_LIGHT}}
				}}
			}}
		}}
	end,
	initial_deck = {Ranks = {} },
	apply = function (self, back)
		local playing_cards = FooBar.generate_playing_cards_table()
		for _, card in ipairs(playing_cards) do
			G.E_MANAGER:add_event(Event({
				func = function()
					SMODS.add_card{
						set = "Base",
						rank = card.rank,
						suit = card.suit,
						edition = card.edition,
						seal = card.seal,
						enhancement = card.enhancement,
						area = G.deck
					}
					return true
				end
			}))
		end
	end
})

function G.FUNCS.foobar_open_edit_deck_allow(e)
	if G.STAGE ~= G.STAGES.RUN then
		e.config.colour = G.C.BLUE
		e.config.button = 'foobar_open_edit_deck'
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

function FooBar.generate_playing_cards_table()
	local ret = {}
	if not G.foobar_create_deck then
		for _, rank in ipairs(SMODS.Rank.obj_buffer) do
			for _, suit in ipairs(SMODS.Suit.obj_buffer) do
				for _ = 1, 2 do
					ret[#ret+1] = {
						rank = rank,
						suit = suit
					}
				end
			end
		end
	else
		for _, card in ipairs(G.foobar_create_deck) do
			local en, _ = next(SMODS.get_enhancements(card))
			ret[#ret+1] = {
				rank = card:get_id(),
				suit = card.base.suit,
				edition = (card.edition or {}).key,
				enhancement = en,
				seal = card.seal
			}
		end
	end
	return ret
end

function G.FUNCS.foobar_open_edit_deck (e)
	G.foobar_create_deck_selected_card = nil
	if not G.foobar_create_deck_selected_card_properties then
		FooBar.reset_selected_card_metatable()
	end
	if not G.foobar_create_deck_points then
		G.foobar_create_deck_points = 1000
	end
	if not G.foobar_create_deck_selected_card_cardarea then
		G.foobar_create_deck_selected_card_cardarea = CardArea(-5, -5, G.CARD_W, G.CARD_H, {
			type="hand",
			bg_colour = G.C.UI.TRANSPARENT_DARK,
			no_card_count = true,
			highlight_limit = 0
		})
	end
	if not G.foobar_create_deck_suit_cardareas then
		G.foobar_create_deck_suit_cardareas = {}
	end
	if not G.foobar_create_deck_cardarea then
		G.foobar_create_deck_cardarea = CardArea(
			-5, -5, G.CARD_W, G.CARD_H,
			{
				card_limit = 0,
				type = 'title',
				view_deck = true,
				highlight_limit = 1,
				card_w = G.CARD_W * 0.7,
				draw_layers = { 'card' },
				negative_info = 'playing_card'
		})
	end
	if not G.foobar_create_deck then 
		G.foobar_create_deck = {}
		for _, rank in ipairs(SMODS.Rank.obj_buffer) do
			for _, suit in ipairs(SMODS.Suit.obj_buffer) do
				for _ = 1, 2 do
					FooBar.create_deck_card(rank, suit)
				end
			end
		end
	end
	G.FUNCS.overlay_menu({definition=G.UIDEF.foobar_edit_deck_ui()})
end

function FooBar.reset_selected_card_metatable()
	if not G.foobar_create_deck_selected_card_properties then
		G.foobar_create_deck_selected_card_properties = setmetatable({}, {
			__index = function(t, k)
				if k == "is" then return nil end
				return "ERROR"
			end
		})
	end
	for key, value in pairs(G.foobar_create_deck_selected_card_properties) do
		G.foobar_create_deck_selected_card_properties.key = nil
	end
	if not G.foobar_create_deck_selected_card_properties_str then
		G.foobar_create_deck_selected_card_properties_str = setmetatable({}, {
			__index = function(t, k)
				if k == "is" then return nil end
				return "None" 
			end
		})
	end
	G.foobar_create_deck_selected_card_properties_str.edition = setmetatable({}, {
		__index = function(t, k)
			return "None" 
		end
	})
	for _, key in ipairs(G.P_CENTER_POOLS.Edition) do
		G.foobar_create_deck_selected_card_properties_str.edition[key.key] = localize{type="name_text", set = "Edition", key = key.key}
	end
	G.foobar_create_deck_selected_card_properties_str.enhancement = setmetatable({}, {
		__index = function(t, k)
			return "None" 
		end
	})
	for _, key in ipairs(G.P_CENTER_POOLS.Enhanced) do
		G.foobar_create_deck_selected_card_properties_str.enhancement[key.key] = localize{type="name_text", set = "Enhanced", key = key.key}
	end
	G.foobar_create_deck_selected_card_properties_str.seal = setmetatable({}, {
		__index = function(t, k)
			return "None" 
		end
	})
	for _, key in ipairs(G.P_CENTER_POOLS.Seal) do
		G.foobar_create_deck_selected_card_properties_str.seal[key.key] = localize{type="name_text", set = "Other", key = key.key:lower() .. "_seal"}
	end
end

function FooBar.update_selected_card(card)
	if G.OVERLAY_MENU then
		G.foobar_create_deck_selected_card = card
		FooBar.reset_selected_card_metatable()
		if G.foobar_create_deck_selected_card_cardarea.cards and G.foobar_create_deck_selected_card_cardarea.cards[1] then
			G.foobar_create_deck_selected_card_cardarea.cards[1]:start_dissolve()
		end
		if card then
			G.foobar_create_deck_selected_card_cardarea:emplace(copy_card(card))
			if card.edition then
				G.foobar_create_deck_selected_card_properties.edition = card.edition.key
			else
				G.foobar_create_deck_selected_card_properties.edition = "e_base"
			end
			local en, _ = next(SMODS.get_enhancements(card))
			if en then
				G.foobar_create_deck_selected_card_properties.enhancement = en
			else
				G.foobar_create_deck_selected_card_properties.enhancement = "c_base"
			end
			if card.seal then
				G.foobar_create_deck_selected_card_properties.seal = card.seal
			else
				G.foobar_create_deck_selected_card_properties.seal = "None"
			end
		else
			G.foobar_create_deck_selected_card_properties.edition = "e_base"
			G.foobar_create_deck_selected_card_properties.enhancement = "c_base"
			G.foobar_create_deck_selected_card_properties.seal = "None"
		end
	end
end

function FooBar.create_deck_card(rank, suit)
	local card = SMODS.create_card({set = "Base", area = G.foobar_create_deck_cardarea, rank = rank, suit = suit, scale = 0.7})
	G.playing_card = (G.playing_card and G.playing_card + 1) or 1
	local _card = copy_card(card, nil, 0.7, G.playing_card)
	G.foobar_create_deck[#G.foobar_create_deck + 1] = copy_card(card, nil, 0.7, G.playing_card)
	card:start_dissolve()
	G.foobar_create_deck_cardarea:emplace(_card)
	_card.foobar_create_deck_card = true
	return _card
end

function G.UIDEF.foobar_edit_deck_ui ()
	return {n=G.UIT.ROOT, config = {align = "cm", minw = G.ROOM.T.w*5, minh = G.ROOM.T.h*5,padding = 0.1, r = 0.1, colour = {G.C.GREY[1], G.C.GREY[2], G.C.GREY[3],0.7}}, nodes={
    {n=G.UIT.R, config={align = "cm", minh = 1,r = 0.3, padding = 0.07, minw = 1, colour = G.C.JOKER_GREY, emboss = 0.1}, nodes={
      {n=G.UIT.C, config={align = "cm", minh = 1,r = 0.2, padding = 0.2, minw = 1, colour = G.C.L_BLACK}, nodes={
        {n=G.UIT.R, config={align = "cm",padding = 0.2, minw = 7}, nodes={
					{n = G.UIT.C, config = {align = "cm", minw = 14}, nodes = {
						{n = G.UIT.O, config = {object = UIBox({definition = FooBar.create_deck_ui(), config = {}})}}
					}},
					{n = G.UIT.C, config = {align = "tm", r=0.2, colour = G.C.UI.TRANSPARENT_DARK}, nodes = {
						create_tabs({
							tabs = {
								{
									label = "Deck",
									chosen = true,
									tab_definition_function = G.UIDEF.foobar_edit_deck_tab
								},
								{
									label = "Card",
									tab_definition_function = G.UIDEF.foobar_edit_card_tab
								}
							}
						})
					}}
        }},
        {n=G.UIT.R, config={id = 'overlay_menu_back_button', align = "cm", minw = 2.5, padding =0.1, r = 0.1, hover = true, colour = G.C.ORANGE, button = "foobar_leave_deck_editor", shadow = true, focus_args = {nav = 'wide', button = 'b'}}, nodes={
          {n=G.UIT.R, config={align = "cm", padding = 0, no_fill = true}, nodes={
            {n=G.UIT.T, config={text = localize('b_back'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true, func = 'set_button_pip', focus_args = {button = 'b'}}}
          }}
        }}
      }}
    }}
  }}
end

function G.UIDEF.foobar_edit_deck_tab ()
	return {n = G.UIT.ROOT, config = {align = "cm", minw = 3, padding = 0.1, r = 0.1, colour = G.C.UI.TRANSPARENT_DARK}, nodes = {
    {n=G.UIT.R, config={align = "cm", minh = 1,r = 0.3, padding = 0.07, minw = 1, colour = G.C.JOKER_GREY, emboss = 0.1}, nodes={
      {n=G.UIT.C, config={align = "cm", minh = 1,r = 0.2, padding = 0.2, minw = 1, colour = G.C.L_BLACK}, nodes={
				{n = G.UIT.C, config = {align = "cm"}, nodes = {
					{n = G.UIT.T, config = {text = "edit deck", scale = 0.5, colour = G.C.UI.TEXT_LIGHT}}
				}}
			}}
		}}
	}}
end

function G.FUNCS.foobar_update_card_enhancement (e)
	if G.foobar_create_deck_selected_card then
		G.foobar_create_deck_selected_card:set_ability(e.config.value)
		G.foobar_create_deck_selected_card_cardarea.cards[1]:set_ability(e.config.value)
	end
end

function G.FUNCS.foobar_update_card_edition (e)
	if G.foobar_create_deck_selected_card then
		G.foobar_create_deck_selected_card:set_edition(e.config.value)
		G.foobar_create_deck_selected_card_cardarea.cards[1]:set_edition(e.config.value)
	end
end

function G.FUNCS.foobar_update_card_seal (e)
	if G.foobar_create_deck_selected_card then
		if e.config.value == "None" then e = {config = {}} end
		G.foobar_create_deck_selected_card:set_seal(e.config.value)
		G.foobar_create_deck_selected_card_cardarea.cards[1]:set_seal(e.config.value)
	end
end

function G.FUNCS.foobar_copy_card (e)
	if G.foobar_create_deck_selected_card then
		G.playing_card = (G.playing_card and G.playing_card + 1) or 1
		local card = copy_card(G.foobar_create_deck_selected_card, nil, 0.7, G.playing_card)
		G.foobar_create_deck_cardarea:emplace(card)
		G.foobar_create_deck_cardarea:remove_card(card)
		G.foobar_create_deck_selected_card.area:emplace(card)
		G.foobar_create_deck[#G.foobar_create_deck+1] = card
		if card:is_face() then
			G.foobar_create_deck_face_tally = G.foobar_create_deck_face_tally + 1
		elseif card:get_id() == 14 then
			G.foobar_create_deck_ace_tally = G.foobar_create_deck_ace_tally + 1
		else
			G.foobar_create_deck_num_tally = G.foobar_create_deck_num_tally + 1
		end
		if card.base.suit then G.foobar_create_deck_suit_tallies[card.base.suit] = (G.foobar_create_deck_suit_tallies[card.base.suit] or 0) + 1 end
		if card.base.value then G.foobar_create_deck_rank_tallies[card.base.value] = G.foobar_create_deck_rank_tallies[card.base.value] + 1 end
		G.E_MANAGER:add_event(Event({
			func = function()
				card.foobar_create_deck_card = true
				card:click()
				return true
			end
		}))
	end
end

function G.FUNCS.foobar_destroy_card (e)
	if G.foobar_create_deck_selected_card then
		local card = G.foobar_create_deck_selected_card
		FooBar.update_selected_card(nil)
		if card:is_face() then
			G.foobar_create_deck_face_tally = G.foobar_create_deck_face_tally - 1
		elseif card:get_id() == 14 then
			G.foobar_create_deck_ace_tally = G.foobar_create_deck_ace_tally - 1
		else
			G.foobar_create_deck_num_tally = G.foobar_create_deck_num_tally - 1
		end
		if card.base.suit then G.foobar_create_deck_suit_tallies[card.base.suit] = (G.foobar_create_deck_suit_tallies[card.base.suit] or 1) - 1 end
		if card.base.value then G.foobar_create_deck_rank_tallies[card.base.value] = G.foobar_create_deck_rank_tallies[card.base.value] - 1 end
		G.E_MANAGER:add_event(Event({
			func = function()
				card:start_dissolve()
				for index, _card in ipairs(G.foobar_create_deck) do
					if _card == card then
						table.remove(G.foobar_create_deck, index)
						break
					end
				end
				return true
			end
		}))
	end
end

function G.UIDEF.foobar_edit_card_tab ()
	G.foobar_create_deck_selected_card_cardarea.cards = {}
	if G.foobar_create_deck_selected_card then
		G.foobar_create_deck_selected_card_cardarea:emplace(copy_card(G.foobar_create_deck_selected_card))
	end
	local valid_enhancement_keys = {"c_base"}
	for _, enhancement in pairs(G.P_CENTER_POOLS.Enhanced) do
		if not enhancement.foobar_ignore then
			valid_enhancement_keys[#valid_enhancement_keys+1] = enhancement.key
		end
	end
	local valid_edition_keys = {}
	for _, edition in pairs(G.P_CENTER_POOLS.Edition) do
		if not edition.foobar_ignore and edition.key ~= "e_negative" then
			valid_edition_keys[#valid_edition_keys+1] = edition.key
		end
	end
	local valid_seal_keys = {"None"}
	for _, seal in pairs(G.P_CENTER_POOLS.Seal) do
		if not seal.foobar_ignore then
			valid_seal_keys[#valid_seal_keys+1] = seal.key
		end
	end
	return {n = G.UIT.ROOT, config = {align = "cm", minw = 3, padding = 0.1, r = 0.1, colour = G.C.UI.TRANSPARENT_DARK}, nodes = {
		{n = G.UIT.R, config = {align = "cm"}, nodes = {
			{n=G.UIT.R, config={align = "cm", minh = 1,r = 0.3, padding = 0.07, minw = 1, colour = G.C.JOKER_GREY, emboss = 0.1}, nodes={
				{n=G.UIT.C, config={align = "cm", minh = 1,r = 0.2, padding = 0.2, minw = 1, colour = G.C.L_BLACK}, nodes={
					{n = G.UIT.R, config = {id = "selected_card", align = "cm"}, nodes = {
						{n = G.UIT.O, config = {object = G.foobar_create_deck_selected_card_cardarea}}
					}}
				}}
			}}
		}},
		{n = G.UIT.R , config = {padding = 0.05, align = "tm", outline = 2, outline_color = G.C.UI.OUTLINE_DARK, r = 0.2}, nodes = {
			{n = G.UIT.C, config = {align = "tm", minw = 3}, nodes = {
				{n = G.UIT.R, config = {align = "cm", padding = 0.2}, nodes = {
					SMODS.GUI.dropdown_select{
						id = "enhancement_select",
						ui_type = G.UIT.C,
						ref_table = G.foobar_create_deck_selected_card_properties,
						ref_value = "enhancement",
						options = valid_enhancement_keys,
						dropdown_element_def = function (option, args)
							return {n = G.UIT.T, config = {text = G.foobar_create_deck_selected_card_properties_str.enhancement[option], scale = 0.3, colour = G.C.UI.TEXT_LIGHT}}
						end,
						max_menu_h = 5,
						callback = "foobar_update_card_enhancement",
						close_on_select = true,
						no_unselect = true,
						display_choice_func = function (option)
							return G.foobar_create_deck_selected_card_properties_str.enhancement[option]
						end,
					}
				}},
				{n = G.UIT.R, config = {align = "cm", padding = 0.2}, nodes = {
					SMODS.GUI.dropdown_select{
						id = "seal_select",
						ui_type = G.UIT.C,
						ref_table = G.foobar_create_deck_selected_card_properties,
						ref_value = "seal",
						options = valid_seal_keys,
						dropdown_element_def = function (option, args)
							return {n = G.UIT.T, config = {text = G.foobar_create_deck_selected_card_properties_str.seal[option], scale = 0.3, colour = G.C.UI.TEXT_LIGHT}}
						end,
						max_menu_h = 5,
						callback = "foobar_update_card_seal",
						close_on_select = true,
						no_unselect = true,
						display_choice_func = function (option)
							return G.foobar_create_deck_selected_card_properties_str.seal[option]
						end,
					},
				}},
				{n = G.UIT.R, config = {align = "cm", padding = 0.2}, nodes = {
					SMODS.GUI.dropdown_select{
						id = "edition_select",
						ui_type = G.UIT.C,
						ref_table = G.foobar_create_deck_selected_card_properties,
						ref_value = "edition",
						options = valid_edition_keys,
						dropdown_element_def = function (option, args)
							return {n = G.UIT.T, config = {text = G.foobar_create_deck_selected_card_properties_str.edition[option], scale = 0.3, colour = G.C.UI.TEXT_LIGHT}}
						end,
						max_menu_h = 5,
						callback = "foobar_update_card_edition",
						close_on_select = true,
						no_unselect = true,
						display_choice_func = function (option)
							return G.foobar_create_deck_selected_card_properties_str.edition[option]
						end,
					}
				}}
			}},
			{n = G.UIT.C, config = {minw = 0.1, r = 0.1, colour = G.C.UI.TEXT_INACTIVE}},
			{n = G.UIT.C, config = {align = "tm"}, nodes = {
				{n = G.UIT.R, config = {align = "cm", padding = 0.2}, nodes = {
					{n = G.UIT.C, config = {align = "cm", padding = 0.2, colour = G.C.RED, r=0.1, button = "foobar_copy_card", shadow = true}, nodes = {
						{n = G.UIT.T, config = {text = "Copy", scale = 0.5, colour = G.C.UI.TEXT_LIGHT}}
					}}
				}},
				{n = G.UIT.R, config = {align = "cm", padding = 0.2}, nodes = {
					{n = G.UIT.C, config = {align = "cm", padding = 0.2, colour = G.C.RED, r=0.1, button = "foobar_destroy_card", shadow = true}, nodes = {
						{n = G.UIT.T, config = {text = "Destroy", scale = 0.5, colour = G.C.UI.TEXT_LIGHT}}
					}}
				}}
			}}
		}}
	}}
end

function G.FUNCS.foobar_leave_deck_editor (e)
	if G.foobar_create_deck then
		for _, card in ipairs(G.foobar_create_deck) do
			if card and card.area then
				card.area:remove_card(card)
				G.foobar_create_deck_cardarea:emplace(card, nil, false)
			end
		end
	end
	return G.FUNCS.setup_run(e)
end

local function fb_tally_sprite (pos, value, tooltip, suit)
	local text_colour = G.C.BLACK
	local ref_table, ref_value = nil, nil
	if type(value) == "table" and value[1].string==value[2].string then
		text_colour = value[1].colour or G.C.WHITE
		ref_table = value[1].ref_table
		ref_value = value[1].ref_value
	end
	local deckskin = suit and SMODS.DeckSkins[G.SETTINGS.CUSTOM_DECK.Collabs[suit]]
	local palette = deckskin and (deckskin.palette_map and deckskin.palette_map[G.SETTINGS.colour_palettes[suit] or ''] or (deckskin.palettes or {})[1])
	local t_s
	if palette and palette.suit_icon and palette.suit_icon.atlas then
		local _x = (suit == 'Spades' and 3) or (suit == 'Hearts' and 0) or (suit == 'Clubs' and 2) or (suit == 'Diamonds' and 1)
		local atlas_key = palette.suit_icon.atlas or 'ui_1'
		t_s = SMODS.create_sprite(0, 0, 0.3, 0.3, atlas_key, (type(palette.suit_icon.pos) == "number" and {x=_x, y=palette.suit_icon.pos}) or palette.suit_icon.pos or {x=_x, y=0})
	elseif suit and (G.SETTINGS.colour_palettes[suit] == 'lc' or G.SETTINGS.colour_palettes[suit] == 'hc') then
		local atlas_key_1 = SMODS.Suits[suit][G.SETTINGS.colour_palettes[suit] == 'hc' and "hc_ui_atlas" or G.SETTINGS.colour_palettes[suit] == 'lc' and "lc_ui_atlas"]
		local atlas_key_2 = ("ui_" .. (G.SETTINGS.colourblind_option and "2" or "1"))
		local atlas = SMODS.get_atlas(atlas_key_1) or SMODS.get_atlas(atlas_key_2)
		t_s = SMODS.create_sprite(0, 0, 0.3, 0.3, atlas, SMODS.Suits[suit].ui_pos)
	else
		local atlas_key_1 = suit and SMODS.Suits[suit][G.SETTINGS.colourblind_option and "hc_ui_atlas" or "lc_ui_atlas"]
		local atlas_key_2 = ("ui_"..(G.SETTINGS.colourblind_option and "2" or "1"))
		local atlas = SMODS.get_atlas(atlas_key_1) or SMODS.get_atlas(atlas_key_2)
		t_s = SMODS.create_sprite(0, 0, 0.5, 0.5, atlas, {x=pos.x or 0, y=pos.y or 0})
	end
	t_s.states.drag.can = false
	t_s.states.hover.can = false
	t_s.states.collide.can = false
	return
	{n=G.UIT.C, config={align = "cm", padding = 0.07,force_focus = true,  focus_args = {type = 'tally_sprite'}, tooltip = {text = tooltip}}, nodes={
		{n=G.UIT.R, config={align = "cm", r = 0.1, padding = 0.04, emboss = 0.05, colour = G.C.JOKER_GREY}, nodes={
			{n=G.UIT.O, config={w=0.5,h=0.5 ,can_collide = false, object = t_s, tooltip = {text = tooltip}}}
		}},
		{n=G.UIT.R, config={align = "cm"}, nodes={
			{n=G.UIT.T, config={ref_table = ref_table, ref_value = ref_value, colour = text_colour, scale = 0.4, shadow = true}},
		}},
	}}
end

function FooBar.create_deck_ui()
	G.foobar_create_deck_face_tally = 0
	G.foobar_create_deck_num_tally = 0
	G.foobar_create_deck_ace_tally = 0
	G.foobar_create_deck_mod_face_tally = 0
	G.foobar_create_deck_mod_num_tally = 0
	G.foobar_create_deck_mod_ace_tally = 0
	G.foobar_create_deck_rank_tallies = {}
	G.foobar_create_deck_suit_tallies = {}
	G.foobar_create_deck_mod_rank_tallies = {}
	G.foobar_create_deck_mod_suit_tallies = {}
	G.foobar_create_deck_suit_cardareas = {}
	local deck_tables = {}
	remove_nils(G.foobar_create_deck)
	local view_deck_unplayed_only = false
	table.sort(G.foobar_create_deck, function(a, b) return a:get_nominal('suit') > b:get_nominal('suit') end)
	local SUITS = {}
	local suit_map = {}
	for i = #SMODS.Suit.obj_buffer, 1, -1 do
		SUITS[SMODS.Suit.obj_buffer[i]] = {}
		suit_map[#suit_map + 1] = SMODS.Suit.obj_buffer[i]
	end
	for k, v in ipairs(G.foobar_create_deck) do
		if v.base.suit then table.insert(SUITS[v.base.suit], v) end
	end
	local num_suits = 0
	for j = 1, #suit_map do
		if SUITS[suit_map[j]][1] then num_suits = num_suits + 1 end
	end

	local visible_suit = {}
	for j = 1, #suit_map do
		if SUITS[suit_map[j]][1] then
			table.insert(visible_suit, suit_map[j])
		end
	end

	for j = 1, #visible_suit do
		if (j >= 1 and j <= 4) or num_suits <= 4 then
			if SUITS[visible_suit[j]][1] then
				local view_deck = CardArea(
					0, 0,
					4.5 * G.CARD_W,
					(0.6) * G.CARD_H,
					{
						card_limit = #SUITS[visible_suit[j]],
						highlight_limit = 1,
						type = "hand",
						card_w = G.CARD_W * 0.5,
						card_h = G.CARD_H * 0.5,
						draw_layers = { 'card' },
						negative_info = 'playing_card',
						no_card_count = true
					})
				G.foobar_create_deck_suit_cardareas[#G.foobar_create_deck_suit_cardareas+1] = view_deck
				table.insert(deck_tables,
					{n = G.UIT.R, config = {align = "cm", padding = 0}, nodes = {
						{n = G.UIT.O, config = {object = view_deck}}}}
				)
				G.E_MANAGER:add_event(Event({
					func = function()
						for i = 1, #SUITS[visible_suit[j]] do
							if SUITS[visible_suit[j]][i] then
								local card = SUITS[visible_suit[j]][i]
								G.foobar_create_deck_cardarea:remove_card(card)
								card.foobar_create_deck_card = true
								view_deck:emplace(card, nil, false)
								-- stupid fricking peice of code that I hate
							end
						end
						return true
					end
				}))
			end
		end
	end

	if not next(deck_tables) then
		local view_deck = CardArea(
			0, 0,
			6.5*G.CARD_W,
			0.6*G.CARD_H,
			{card_limit = 1, type = 'title', view_deck = true, highlight_limit = 0, card_w = G.CARD_W*0.7, draw_layers = {'card'}, negative_info = 'playing_card'})
		table.insert(
			deck_tables,
			{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
				{n=G.UIT.O, config={object = view_deck}}
			}}
		)
	end

	local flip_col = G.C.WHITE

	for _, v in ipairs(suit_map) do
		G.foobar_create_deck_suit_tallies[v] = 0
		G.foobar_create_deck_mod_suit_tallies[v] = 0
	end
	local rank_name_mapping = SMODS.Rank.obj_buffer
	for _, v in ipairs(rank_name_mapping) do
		G.foobar_create_deck_rank_tallies[v] = 0
		G.foobar_create_deck_mod_rank_tallies[v] = 0
	end
	local mod_ace_tally = 0
	local wheel_flipped = 0

	for k, v in ipairs(G.foobar_create_deck) do
		if v.ability.name ~= 'Stone Card' then
			local v_nr, v_ns = SMODS.has_no_rank(v), SMODS.has_no_suit(v)
			--For the suits
			if v.base.suit and not v_ns then G.foobar_create_deck_suit_tallies[v.base.suit] = (G.foobar_create_deck_suit_tallies[v.base.suit] or 0) + 1 end
			for kk, vv in pairs(G.foobar_create_deck_mod_suit_tallies) do
				G.foobar_create_deck_mod_suit_tallies[kk] = (vv or 0) + (v:is_suit(kk) and 1 or 0)
			end

			--for face cards/numbered cards/aces
			local card_id = v:get_id()
			if v.base.value and not v_nr then G.foobar_create_deck_face_tally = G.foobar_create_deck_face_tally + ((SMODS.Ranks[v.base.value].face) and 1 or 0) end
			G.foobar_create_deck_mod_face_tally = G.foobar_create_deck_mod_face_tally + (v:is_face() and 1 or 0)
			if v.base.value and not v_nr and not SMODS.Ranks[v.base.value].face and card_id ~= 14 then
				G.foobar_create_deck_num_tally = G.foobar_create_deck_num_tally + 1
				if not v.debuff then G.foobar_create_deck_mod_num_tally = G.foobar_create_deck_mod_num_tally + 1 end
			end
			if card_id == 14 then
				G.foobar_create_deck_ace_tally = G.foobar_create_deck_ace_tally + 1
				if not v.debuff then G.foobar_create_deck_mod_ace_tally = G.foobar_create_deck_mod_ace_tally + 1 end
			end

			--ranks
			if v.base.value and not v_nr then G.foobar_create_deck_rank_tallies[v.base.value] = G.foobar_create_deck_rank_tallies[v.base.value] + 1 end
			if v.base.value and not v_nr and not v.debuff then G.foobar_create_deck_mod_rank_tallies[v.base.value] = G.foobar_create_deck_mod_rank_tallies[v.base.value] + 1 end
		end
	end
	local modded = G.foobar_create_deck_face_tally ~= G.foobar_create_deck_mod_face_tally
	for kk, vv in pairs(G.foobar_create_deck_mod_suit_tallies) do
		modded = modded or (vv ~= G.foobar_create_deck_suit_tallies[kk])
		if modded then break end
	end

    local rank_cols = {}
    local temp_cols = {}

    for i = #rank_name_mapping, 1, -1 do
        if G.foobar_create_deck_rank_tallies[rank_name_mapping[i]] ~= 0 or SMODS.add_to_pool(SMODS.Ranks[rank_name_mapping[i]], { suit = '' }) then
			local mod_delta =G.foobar_create_deck_mod_rank_tallies[rank_name_mapping[i]] ~= G.foobar_create_deck_rank_tallies[rank_name_mapping[i]]
            temp_cols[#temp_cols + 1] = {n = G.UIT.R, config = {align = "cm", padding = 0.07}, nodes = {
				{n = G.UIT.C, config = {align = "cm", r = 0.1, padding = 0.04, emboss = 0.04, minw = 0.5, colour = G.C.L_BLACK}, nodes = {
					{n = G.UIT.T, config = {text = SMODS.Ranks[rank_name_mapping[i]].shorthand, colour = G.C.JOKER_GREY, scale = 0.35, shadow = true}},}},
				{n = G.UIT.C, config = {align = "cr", minw = 0.4}, nodes = {
					{n = G.UIT.T, config = {ref_table = G.foobar_create_deck_rank_tallies, ref_value = rank_name_mapping[i], colour = flip_col, scale = 0.45, shadow = true } },}}}}

            if #temp_cols >= 13 then
                rank_cols[#rank_cols + 1] = {
                    n = G.UIT.C,
                    config = { align = "cm" },
                    nodes = temp_cols
                }
                temp_cols = {}
            end
        end
    end

    if #temp_cols > 0 then
        rank_cols[#rank_cols + 1] = {
            n = G.UIT.C,
            config = { align = "cm" },
            nodes = temp_cols
        }
    end

	local tally_ui = {
		-- base cards
		{n = G.UIT.R, config = {align = "cm", minh = 0.05, padding = 0.07}, nodes = {
			{n = G.UIT.O, config = {
					object = DynaText({
						string = {
							{ string = localize('k_base_cards'), colour = G.C.RED }
						},
						colours = { G.C.RED }, silent = true, scale = 0.4, pop_in_rate = 10, pop_delay = 4
					})
				}}}},
		-- aces, faces and numbered cards
		{n = G.UIT.R, config = {align = "cm", minh = 0.05, padding = 0.1}, nodes = {
			fb_tally_sprite(
				{ x = 1, y = 0 },
				{ { ref_table = G, ref_value = "foobar_create_deck_ace_tally", colour = flip_col }, {ref_table = G, ref_value = "foobar_create_deck_mod_ace_tally", colour = G.C.BLUE } },
				{ localize('k_aces') }
			), --Aces
			fb_tally_sprite(
				{ x = 2, y = 0 },
				{ { ref_table = G, ref_value = "foobar_create_deck_face_tally", colour = flip_col }, { ref_table = G, ref_value = "foobar_create_deck_mod_face_tally", colour = G.C.BLUE } },
				{ localize('k_face_cards') }
			), --Face
			fb_tally_sprite(
				{ x = 3, y = 0 },
				{ { ref_table = G, ref_value = "foobar_create_deck_num_tally", colour = flip_col }, { ref_table = G, ref_value = "foobar_create_deck_mod_num_tally", colour = G.C.BLUE } },
				{ localize('k_numbered_cards') }
			), --Numbers
		}},
	}
	-- add suit tallies
	local hidden_suits = {}
	for _, suit in ipairs(suit_map) do
		if G.foobar_create_deck_suit_tallies[suit] == 0 and SMODS.Suits[suit].in_pool and not SMODS.add_to_pool(SMODS.Suits[suit], {rank=''}) then
			hidden_suits[suit] = true
		end
	end
	local i = 1
	local num_suits_shown = 0
	for i = 1, #suit_map do
		if not hidden_suits[suit_map[i]] then
			num_suits_shown = num_suits_shown+1
		end
	end
	local suits_per_row = 2
	local n_nodes = {}
	local visible_suits = {}
	local temp_list = {}
	while i <= math.min(4, #visible_suit) do
		if not hidden_suits[visible_suit[i]] then
			table.insert(n_nodes, fb_tally_sprite(
				SMODS.Suits[visible_suit[i]].ui_pos,
				{
					{ ref_table = G.foobar_create_deck_suit_tallies, ref_value = visible_suit[i], colour = flip_col },
					{ ref_table = G.foobar_create_deck_mod_suit_tallies, ref_value = visible_suit[i], colour = G.C.BLUE }
				},
				{ localize(visible_suit[i], 'suits_plural') },
				visible_suit[i]
			))
			table.insert(visible_suits, i)
		end
		if #n_nodes == suits_per_row then
			table.insert(temp_list, n_nodes)
			n_nodes = {}
		end
		i = i + 1
	end
	if #n_nodes > 0 then
		table.insert(temp_list, n_nodes)
	end

	local index = 0
	local second_temp_list = {}
	for _, v in ipairs(temp_list) do
		local n = {n = G.UIT.R, config = {align = "cm", minh = 0.05, padding = 0.05}, nodes = v}
		table.insert(tally_ui, n)
	end

	local suit_options = {}
	for i = 1, math.ceil(#visible_suit / 4) do
		table.insert(suit_options,
			localize('k_page') .. ' ' .. tostring(i) .. '/' .. tostring(math.ceil(#visible_suit / 4)))
	end

	local object = {n = G.UIT.ROOT, config = {align = "cm", colour = G.C.CLEAR}, nodes = {
		{n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {}},
		{n = G.UIT.R, config = {align = "cm"}, nodes = {
			{n = G.UIT.C, config = {align = "cm", minw = 1.5, minh = 2, r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes = {
				{n = G.UIT.C, config = {align = "tm", padding = 0.1}, nodes = {
					{n = G.UIT.R, config = {align = "cm", r = 0.1, colour = G.C.L_BLACK, emboss = 0.05, padding = 0.15}, nodes = {
						{n = G.UIT.T, config = {text = "Edit Your Deck", scale = 0.7, colour = G.C.UI.TEXT_LIGHT}}
					}},
					{n = G.UIT.R, config = {align = "cm", r = 0.1, outline_colour = G.C.L_BLACK, line_emboss = 0.05, outline = 1.5}, nodes = tally_ui},
					{n = G.UIT.R, config = {align = "cm"}, nodes = {
						{n = G.UIT.T, config = {scale = 0.5, text = "Points Left: ", colour = G.C.UI.TEXT_LIGHT}},
						{n = G.UIT.T, config = {ref_table = G, ref_value = "foobar_create_deck_points", scale = 0.5, colour = G.C.UI.TEXT_LIGHT}}
					}}
				}},
				{n = G.UIT.C, config = {align = "cm"}, nodes = rank_cols},
				{n = G.UIT.B, config = {w = 0.1, h = 0.1}},
			}},
			{n = G.UIT.B, config = {w = 0.2, h = 0.1}},
			{n = G.UIT.C, config = {align = "cm", padding = 0.1, r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes = deck_tables}
		}},
		#visible_suit > 4 and {n = G.UIT.R, config = {align = "cm", padding = 0 }, nodes = {
			create_option_cycle({
				options = suit_options,
				w = 4.5,
				cycle_shoulders = true,
				opt_callback =
				'your_suits_page',
				focus_args = { snap_to = true, nav = 'wide' },
				current_option = 1,
				colour = G.C.RED,
				no_pips = true,
			})
		}} or nil,
	}}
	local t = {n = G.UIT.ROOT, config = {align = "cm", minw = 3, padding = 0.1, r = 0.1, colour = G.C.CLEAR}, nodes = {
		{n = G.UIT.O, config = {
				id = 'suit_list',
				object = UIBox {
					definition = object, config = {offset = { x = 0, y = 0 }, align = 'cm'}
				}
			}}}}
	return t
end

