FooBar.Minigame{
	key="minesweeper",
	tag_pos = {x=2,y=0},
	config = {
		size = 13,
		grid = {},
		ref_tables = {},
		mines = 30,
		mines_pos = {},
		flag_state = "Reveal",
		flag_states = {
			REVEAL = "Reveal",
			FLAG = "Flag",
			MINE = "Failure!",
			WIN = "Success!"
		},
		mines_flagged = 0,
		mines_flagged_question = "",
		mines_flagged_question_part_2 = "",
		cells_revealed = 0,

		allow_inputs = true,

		mine_size = 50,
		mine_colors = {
			HEX("0CF017"),
			HEX("79ED12"),
			HEX("E2ED0A"),
			HEX("EBD50C"),
			HEX("EC930D"),
			HEX("EF6808"),
			HEX("F43809"),
			HEX("FF0000")
		},
		other_mod = "no joke for you",
		other_mod_unloaded = "this shouldn't appear"
	},
	set_ability = function(self)
		-- grid initialization
		for row=1,self.ability.size do
			self.ability.grid[row] = {}
			for col=1,self.ability.size do
				self.ability.grid[row][col] = {flag=false,revealed=false,mine=false,number=0}
			end
		end

		-- spread mines
		local SAFE_AREA_RADIUS = 1
		for i = 1, self.ability.mines do
			while true do
				local row, col = math.random(1, self.ability.size), math.random(1, self.ability.size)
				if math.abs(row - (self.ability.size + 1) / 2) <= SAFE_AREA_RADIUS and math.abs(col - (self.ability.size + 1) / 2) <= SAFE_AREA_RADIUS then
					goto continue
				end
				if not self.ability.grid[row][col].mine then
					table.insert(self.ability.mines_pos, {row, col})
					self.ability.grid[row][col].mine = true
					break
				end
				::continue::
			end
		end

		-- update numbers
		local index_check = {{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}}
		for rowi, row in ipairs(self.ability.grid) do
			for coli, col in ipairs(row) do
				if not col.mine then
					local count = 0
					for _, di in ipairs(index_check) do
						local dr, dc = di[1], di[2]
						if rowi + dr >= 1 and rowi + dr <= self.ability.size and coli + dc >= 1 and coli + dc <= self.ability.size then
							if self.ability.grid[rowi + dr][coli + dc].mine then
								count = count + 1
							end
						end
					end
					col.number = count
				end
			end
		end

		-- ref_table initialization
		for row=1,self.ability.size do
			self.ability.ref_tables[row] = {}
			for col=1,self.ability.size do
				self.ability.ref_tables[row][col] = {content=self:generate_cell_text(self.ability.grid[row][col])}
			end
		end

		self.ability.mines_flagged = self.ability.mines

		-- choose random mod to flame
		local choices = {}
		local not_loaded = {}
		for key, mod in pairs(SMODS.Mods) do
			if mod.can_load then
				table.insert(choices, mod.name)
			else
				table.insert(not_loaded, mod.name)
			end
		end
		self.ability.other_mod = "Wanna hear a joke? " .. choices[math.random(1, #choices)]
		if #not_loaded == 0 then
			self.ability.other_mod_unloaded = "Oh hey your using all your mods"
		else
			self.ability.other_mod_unloaded = "What did " .. not_loaded[math.random(1, #not_loaded)] .. " do to you?"
		end
	end,
	post_ui_creation = function(self)
		self:click_cell((self.ability.size + 1) / 2, (self.ability.size + 1) / 2)
	end,
	generate_minefield_ui = function(self)
		local ret = {}
		local SCALE = 0.75
		for rowi, row in ipairs(self.ability.grid) do
			table.insert(ret, {n=G.UIT.R, nodes={}})
			for coli, cell in ipairs(row) do
				table.insert(ret[#ret].nodes, {n=G.UIT.C, config = {
						align="cm",
						padding=0.1,
						outline=2,
						outline_colour=lighten(G.C.GREY, 0.4),
						minw=SCALE,
						minh=SCALE,
						maxw=SCALE,
						maxh=SCALE,
						colour=lighten(G.C.GREY, 0.5),
						hover=true,
						ref_table = {
							row = rowi,
							col = coli,
							cell = cell
						},
						id = "cell_" .. rowi .. "_" .. coli,
						button='foobar_minigame_minesweeper_click_mine',
						button_dist=0
					}, nodes={
						{n=G.UIT.T, config={scale=0.375,ref_value="content",ref_table=self.ability.ref_tables[rowi][coli], colour=G.C.RED}}
				}})
			end
		end
		return ret
	end,
	generate_gameplay_ui = function(self)
		self.ability.emotional_support_card = CardArea(0, 0, G.CARD_W, G.CARD_H, {
			type="hand",
			bg_colour = G.C.UI.TRANSPARENT_DARK,
			no_card_count = true
		})
		self.ability.emotional_support_card:emplace(copy_card(G.deck.cards[1]))
		local ret = {
			{n=G.UIT.C, nodes = self:generate_minefield_ui()},
			{n=G.UIT.B, config={w=2,h=1}},
			{n=G.UIT.C, config = {align="tm", colour = G.C.UI.BACKGROUND_DARK, outline=2, outline_colour=G.C.UI.OUTLINE_DARK, r=2, padding=0.1}, nodes = {
				{n = G.UIT.R, config = {align="cm", colour = G.C.ORANGE, padding=0.2, r=0.5, minh=1, button="foobar_minigame_minesweeper_toggle_click", hover=true, shadow=true}, nodes = {
					{n = G.UIT.T, config = {colour = G.C.UI.TEXT_LIGHT, scale=1, ref_value = "flag_state", ref_table = self.ability}},
				}},
				{n = G.UIT.R, nodes = {
					{n = G.UIT.B, config={w=1,h=0.2}}
				}},
				{n = G.UIT.R, config = {align="cm", h=0.5}, nodes={
					{n = G.UIT.T, config = {colour = G.C.UI.TEXT_LIGHT, scale=0.5, text = "Mines Left: "}},
					{n = G.UIT.T, config={colour=G.C.UI.TEXT_LIGHT,scale=0.5,ref_value="mines_flagged",ref_table=self.ability}},
					{n = G.UIT.T, config = {colour = G.C.UI.TEXT_LIGHT, scale=0.5, ref_value = "mines_flagged_question", ref_table = self.ability}},
				}},
				{n = G.UIT.R, config = {align="cm"}, nodes = {
					{n = G.UIT.T, config = {colour = G.C.UI.TEXT_LIGHT, scale=0.3, ref_value = "mines_flagged_question_part_2", ref_table = self.ability}}
				}},
				{n = G.UIT.R, nodes = {
					{n = G.UIT.B, config={w=1,h=0.5}}
				}},
				{n = G.UIT.R, config = {align="tm", minh=6.5, padding=0.2, r=1.5, outline=2, outline_colour=G.C.UI.OUTLINE_LIGHT_TRANS, colour=G.C.UI.BACKGROUND_LIGHT}, nodes = {
					{n = G.UIT.R, config = {align="cm",minh=0.75, button="foobar_minigame_minesweeper_give_up", func="foobar_minigame_minesweeper_can_give_up", shadow=true,hover=true,colour=G.C.RED, padding=0.2, r=0.5}, nodes = {
						{n = G.UIT.T, config={colour=G.C.UI.TEXT_LIGHT, scale=0.75, text="Give Up"}}
					}},
					{n = G.UIT.R, config={align="cm", padding=0.2, r=0.5, outline=2, outline_colour=G.C.UI.OUTLINE_DARK, colour=G.C.UI.BACKGROUND_DARK}, nodes = {
						{n = G.UIT.R, config = {align="cm",r=0.5,padding=0.1,colour=G.C.UI.BACKGROUND_INACTIVE}, nodes = {
							{n = G.UIT.T, config = {text="Quip-o-matic 5000", scale=0.5, colour=G.C.UI.TEXT}}
						}},
						{n = G.UIT.R, config = {align="cm", maxw=4}, nodes = {
							{n = G.UIT.O, config={object=DynaText({
								string = {
									{string = "You got this bro", condition = function() return not self:can_continue() end},
									"Where'd the cards go?",
									"Balatro, my favorite logic game",
									{string = "Yo don't choke", condition = function() return not self:can_continue() and self.ability.mines - self.ability.mines_flagged == 1 end},
									{string = "You know there's only " .. self.ability.mines .. " mines, right?", condition = function() return self.ability.mines_flagged < 0 end},
									{string = "You seem to have created mines??", condition = function() return self.ability.mines_flagged > self.ability.mines end},
									{ref_value = "other_mod_unloaded", ref_table = self.ability},
									"One of these have a spelling error btw",
									-- community ones
									{string = "Better watch your step next time!", condition = function() return self.ability.flag_state == self.ability.flag_states.MINE end},
									"ts quipping me",
									"It's like some sort of sweeper of mines over here...",
									{ref_value = "other_mod", ref_table = self.ability},
									"Have you found the 9 yet?",
									"Take a 50/50",
									"Jimbosweeper",
									{string = "Should've covered my ears...", condition = function() return self.ability.flag_state == self.ability.flag_states.MINE end},
									"Need a hint? One of those cells has a mine in it",
									-- if you wanna add your own patch before this
								},
								colours = { G.C.UI.TEXT_LIGHT },
								pop_in_rate = 2,
								pop_out_rate = 2,
								random_element = true,
								pop_delay = 0.2011,
								scale = 0.32,
								min_cycle_time = 5
							})}}
						}}
					}},
					{n = G.UIT.R, config = {align = "cm"}, nodes = {
						{n = G.UIT.C, config = {align = "cm"}, nodes = {
							{n = G.UIT.R, config = {align="cm"}, nodes = {
								{n = G.UIT.T, config = {text = "Emotional", scale=1, colour=G.C.UI.TEXT_LIGHT}}
							}},
							{n = G.UIT.R, config = {align="cm"}, nodes = {
								{n = G.UIT.T, config = {text = "Support", scale=1, colour=G.C.UI.TEXT_LIGHT}}
							}},
							{n = G.UIT.R, config = {align="cm"}, nodes = {
								{n = G.UIT.T, config = {text = "Card", scale=1, colour=G.C.UI.TEXT_LIGHT}}
							}}
						}},
						{n = G.UIT.C, nodes = {
							{n = G.UIT.B, config = {w=0.2,h=1}},
						}},
						{n = G.UIT.C, config = {align = "cm"}, nodes = {
							{n = G.UIT.O, config = {object=self.ability.emotional_support_card}}
						}}
					}},
					{n = G.UIT.R, config = {align="cm", colour = G.C.ORANGE, padding=0.2, r=0.5, minh=1, button="foobar_minigame_get_reward", func='foobar_minigame_minesweeper_can_continue', hover=true, shadow=true}, nodes = {
						{n=G.UIT.T, config={text="Continue!",scale=0.7,colour=G.C.UI.TEXT_LIGHT}}
					}}
				}}
			}}
		}
		return ret
	end,
	click_cell = function(self, row, col)
		local cell = self.ability.grid[row][col]
		if self.ability.flag_state == self.ability.flag_states.MINE then
			cell.flag = false
			cell.revealed = true
			G.foobar_minigame:get_UIE_by_ID("cell_" .. row .. "_" .. col).config.colour = darken(lighten(G.C.GREY, 0.5), 0.1)
			self:update_cell(row, col)
		end
		if self.ability.flag_state == self.ability.flag_states.REVEAL then
			if not cell.revealed then
				if not cell.flag then
					self.ability.cells_revealed = self.ability.cells_revealed + 1
					cell.revealed = true
					local CELL = G.foobar_minigame:get_UIE_by_ID("cell_" .. row .. "_" .. col)
					CELL.config.colour = darken(lighten(G.C.GREY, 0.5), 0.1)
					if cell.number then CELL.children[1].config.colour = self.ability.mine_colors[cell.number] or G.C.BLACK end
					self:update_cell(row, col)
					if not cell.mine and self.ability.cells_revealed == self.ability.size ^ 2 - self.ability.mines and self.ability.mines_flagged == 0 then
						self:win()
					end
					-- empty cells should spread out
					if cell.number == 0 and not cell.mine then
						local index_check = {{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}}
						for _, dindex in ipairs(index_check) do
							local drow, dcol = row + dindex[1], col + dindex[2]
							if drow < 1 or drow > self.ability.size or dcol < 1 or dcol > self.ability.size then else -- do nothing
								self:click_cell(drow, dcol)
							end
						end
					end
					-- mines should explode
					if cell.mine then
						self:reveal_mines()
					end
				end
			end
		end
		if self.ability.flag_state == self.ability.flag_states.FLAG then
			if not cell.revealed then
				if cell.flag then
					self.ability.mines_flagged = self.ability.mines_flagged + 1
				else
					self.ability.mines_flagged = self.ability.mines_flagged - 1
				end
				if self.ability.mines_flagged > self.ability.mines then
					self.ability.mines_flagged_question = "?"
					self.ability.mines_flagged_question_part_2 = "There's only " .. self.ability.mines .. " mines how did you do this"
				elseif self.ability.mines_flagged < 0 then
					self.ability.mines_flagged_question = "?"
					self.ability.mines_flagged_question_part_2 = "I think you might have counted wrong"
				else
					self.ability.mines_flagged_question = ""
					self.ability.mines_flagged_question_part_2 = ""
				end
				cell.flag = not cell.flag
				self:update_cell(row, col)
			end
		end
	end,
	update_cell = function(self, row, col)
		self.ability.ref_tables[row][col].content=self:generate_cell_text(self.ability.grid[row][col])
	end,
	generate_cell_text = function(self, cell)
		return cell.flag and "!" or not cell.revealed and "" or (cell.mine and "X" or (cell.number == 0 and "" or cell.number))
	end,
	toggle_click = function(self)
		if self.ability.flag_state == self.ability.flag_states.MINE or self.ability.flag_state == self.ability.flag_states.WIN then
			return
		end
		if self.ability.flag_state == self.ability.flag_states.REVEAL then
			self.ability.flag_state = self.ability.flag_states.FLAG
		else
			self.ability.flag_state = self.ability.flag_states.REVEAL
		end
	end,
	reveal_mines = function(self)
		self.ability.flag_state = self.ability.flag_states.MINE
		for _, mine in ipairs(self.ability.mines_pos) do
			G.E_MANAGER:add_event(Event({
				trigger = "immediate",
				func = function()
					self:click_cell(mine[1], mine[2])
					return true
				end
			}))
		end
	end,
	win = function(self)
		self.ability.flag_state = self.ability.flag_states.WIN
	end,
	can_continue = function(self)
		return self.ability.flag_state == self.ability.flag_states.WIN or self.ability.flag_state == self.ability.flag_states.MINE
	end,
	can_get_reward = function(self)
		return self.ability.flag_state == self.ability.flag_states.WIN
	end,
	can_give_up = function(self)
		return not self:can_continue()
	end,
	get_reward = function(self, e)
		if self.ability.emotional_support_card and self.ability.emotional_support_card.cards[1] then
			self.ability.emotional_support_card.cards[1]:set_edition("e_negative")
		end
		G.deck.cards[1]:set_edition("e_negative")
	end
}

function G.FUNCS.foobar_minigame_minesweeper_click_mine (e)
	if not e.config.ref_table.revealed then
		G.FOOBAR_MINIGAMES[G.GAME.foobar_current_minigame]:click_cell(e.config.ref_table.row, e.config.ref_table.col)
	end
end

function G.FUNCS.foobar_minigame_minesweeper_toggle_click (e)
	G.FOOBAR_MINIGAMES[G.GAME.foobar_current_minigame]:toggle_click()
end

function G.FUNCS.foobar_minigame_minesweeper_give_up (e)
	G.FOOBAR_MINIGAMES[G.GAME.foobar_current_minigame]:reveal_mines()
end

function G.FUNCS.foobar_minigame_minesweeper_can_continue (e)
	if G.FOOBAR_MINIGAMES[G.GAME.foobar_current_minigame]:can_continue() then 
			e.config.colour = G.C.ORANGE
			e.config.button = 'foobar_minigame_get_reward'
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

function G.FUNCS.foobar_minigame_minesweeper_can_give_up (e)
	if G.FOOBAR_MINIGAMES[G.GAME.foobar_current_minigame]:can_give_up() then
		e.config.colour = G.C.RED
		e.config.button = 'foobar_minigame_minesweeper_give_up'
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end