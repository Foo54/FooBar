FooBar.pjsk_charts = {}
FooBar.pjsk_chart_keys = {}
FooBar.pjsk_chart_info = {}

print("Foobar > projectsekai | Loading chart data")
local files = NFS.getDirectoryItems("" .. SMODS.current_mod.path .. "assets/minigames/projectsekai/charts")
for _, file in ipairs(files) do
	if file:match(".lua$") and file ~= "testing.lua" then
		print("FooBar | Loading chart data " .. file)
		local ret = assert(SMODS.load_file("assets/minigames/projectsekai/charts/" .. file))()
		if ret then 
			FooBar.pjsk_charts[ret.key] = ret.chart 
			FooBar.pjsk_chart_keys[#FooBar.pjsk_chart_keys+1] = ret.key
			FooBar.pjsk_chart_info[ret.key] = {
				title = ret.title,
				artists = ret.artists
			}
			print(ret.key)
			SMODS.Sound{
				key = "music_"..ret.key,
				path = ret.key .. ".ogg",
				sync = false,
				pitch=1,
				select_music_track = function(self)
					return G and G.GAME and G.GAME.FOOBAR_MINIGAME and G.FOOBAR_MINIGAMES and G.GAME.foobar_current_minigame and G.GAME.foobar_current_minigame == "fbminigame_foobar_projectsekai" and G.FOOBAR_MINIGAMES[G.GAME.foobar_current_minigame] and G.FOOBAR_MINIGAMES[G.GAME.foobar_current_minigame].ability.current_song == ret.key and G.FOOBAR_MINIGAMES[G.GAME.foobar_current_minigame].ability.timer > 0 and 100000
				end
			}
		end
	end
end

FooBar.Minigame{
	key="projectsekai",
	config = {
		-- title info
		title = "",
		artists = {},
		title_timer = 0,
		cover_path = "",

		-- gameplay info
		perfect = 0,
		great = 0,
		good = 0,
		bad = 0,
		miss = 0,
		best_combo = 0,
		current_combo = 0,
		combo_animation = 0,
		health = 1000,
		ease_health = 1000,

		-- clear mesage info
		clear_timer = 0,

		-- success message info
		message_timer = 0,

		-- results info
		results_y_offset = 1,
		results_ui = nil,

		-- note info
		notes = {},
		future_notes = {}, -- THIS MUST BE SORTED BY TIME
		timer = -2,

		-- song info
		current_song = "",

		-- keys
		highlights = {0, 0, 0, 0, 0, 0, 0, 0},
		pressed = {false, false, false, false, false, false, false, false},
		keybinds = {"a", "s", "d", "f", "j", "k", "l", ";"},

		-- config
		note_speed = 6,

		-- state
		state = 0,
		states = {
			CARD = 0,
			GAMEPLAY = 1,
			CLEAR = 2,
			MESSAGE = 3,
			RESULTS = 4
		},
		state_complete = false
	},
	set_ability = function(self)
		self.ability.current_song = pseudorandom_element(FooBar.pjsk_chart_keys, "foobar_minigame_pjsk_songchoice")
		self.ability.future_notes = copy_table(FooBar.pjsk_charts[self.ability.current_song])
		self.ability.title = FooBar.pjsk_chart_info[self.ability.current_song].title
		self.ability.artists = copy_table(FooBar.pjsk_chart_info[self.ability.current_song].artists)
		self.ability.cover_path = "Mods/FooBar/assets/covers/" .. self.ability.current_song .. ".png"
		self.ability.cover_image = love.graphics.newImage(self.ability.cover_path)
	end,
	love_update = function(self, dt)
		if G.SETTINGS.paused then return end
		dt = G and G.real_dt or dt
		if self.ability.state == self.ability.states.CARD then
			self:update_title_card(dt)
		end
		if self.ability.state == self.ability.states.GAMEPLAY then
			self:update_gameplay(dt)
		end
		if self.ability.state == self.ability.states.CLEAR then
			self:update_clear(dt)
		end
		if self.ability.state == self.ability.states.MESSAGE then
			self:update_message(dt)
		end
		if self.ability.state == self.ability.states.RESULTS then
			self:update_results(dt)
		end
	end,
	update_results = function(self, dt)
		if not self.ability.results_ui then
			self.ability.results_ui = UIBox{
				definition = self:generate_results_ui(),
				config = {align="bm",offset = {x=0,y=-8}, major=G.ROOM_ATTACH, type="room", bond = 'Weak', instance_type="NODE"}
			}
		end
		self.ability.results_y_offset = self.ability.results_y_offset * 0.9
	end,
	update_clear = function(self, dt)
		local TIMER_DURATION = 3
		self.ability.clear_timer = self.ability.clear_timer + dt
		if self.ability.clear_timer > TIMER_DURATION then
			self.ability.state = self.ability.states.MESSAGE
		end
	end,
	update_message = function(self, dt)
		local TIMER_DURATION = 3
		self.ability.message_timer = self.ability.message_timer + dt
		if self.ability.message_timer > TIMER_DURATION then
			self.ability.state = self.ability.states.RESULTS
		end
	end,
	update_title_card = function(self, dt)
		local TIMER_DURATION = 5
		self.ability.title_timer = self.ability.title_timer + dt
		if self.ability.title_timer > TIMER_DURATION then
			self.ability.state = self.ability.states.GAMEPLAY
		end
	end,
	update_gameplay = function(self, dt)
		self.ability.timer = self.ability.timer + dt

		-- inputs
		for i=1,#self.ability.keybinds do
			if love.keyboard.isDown(self.ability.keybinds[i]) then
				if not self.ability.pressed[i] then
					self.ability.pressed[i] = true
					self.ability.highlights[i] = 1
				end
			else self.ability.pressed[i] = false end
		end

		-- move notes and input detection
		local width, height = love.graphics.getDimensions()
		local DY = 200
		local PERFECT_TIMING = 41.7
		local GREAT_TIMING = 83.3
		local GOOD_TIMING = 108.3
		local BAD_TIMING = 125
		local TOLERANCE = 10
		local RELEASE_TOLERANCE = 0.1
		for i=#self.ability.notes, 1, -1 do
			self.ability.notes[i].y = self.ability.notes[i].y + DY * self.ability.note_speed * dt
			if self.ability.notes[i].y > height then
				if self.ability.notes[i].type > 9 then table.remove(self.ability.notes, i)
				else self:miss_note(i) end
			else
				for k=1, self.ability.notes[i].width do
					if self.ability.notes[i].type <= 2 or self.ability.notes[i].type == 6 or self.ability.notes[i].type == 7 then
						if self.ability.pressed[self.ability.notes[i].x + k - 1] and self.ability.highlights[self.ability.notes[i].x + k - 1] == 1 then
							local dif = math.abs(self.ability.timer - self.ability.notes[i].time) * 1000
							local flag = false
							if dif <= PERFECT_TIMING then self:perfect_note(i)
							elseif dif <= GREAT_TIMING then self:great_note(i)
							elseif dif <= GOOD_TIMING then self:good_note(i)
							elseif dif <= BAD_TIMING then self:bad_note(i)
							else flag = true end
							if not flag then break end
						end
					elseif self.ability.notes[i].type <= 5 then -- trace notes
						if self.ability.pressed[self.ability.notes[i].x + k - 1] then
							local dif = math.abs(self.ability.timer - self.ability.notes[i].time) * 1000
							if dif <= TOLERANCE then
								self:perfect_note(i)
							end
						end
					elseif self.ability.notes[i].type <= 9 then -- hold notes end
						if self.ability.highlights[self.ability.notes[i].x + k - 1] ~= 1 and self.ability.highlights[self.ability.notes[i].x + k - 1] + RELEASE_TOLERANCE >= 0.75 and not self.ability.pressed[self.ability.notes[i].x + k - 1] then
							local dif = math.abs(self.ability.timer - self.ability.notes[i].time) * 1000
							if dif <= PERFECT_TIMING then self:perfect_note(i)
							elseif dif <= GREAT_TIMING then self:great_note(i)
							elseif dif <= GOOD_TIMING then self:good_note(i)
							elseif dif <= BAD_TIMING then self:bad_note(i) end
						end
					end
				end
			end
		end

		-- highlight fade out
		for i=1,#self.ability.highlights do
			self.ability.highlights[i] = math.max(self.ability.pressed[i] and 0.75 or 0, self.ability.highlights[i] - dt)
		end

		-- add new notes
		local BAR_WIDTH = 0.45
		local REACTION_TIME = (height * 0.8) / (DY * self.ability.note_speed)
		while self.ability.future_notes[1] and self.ability.future_notes[1].time - REACTION_TIME <= self.ability.timer do
			self.ability.notes[#self.ability.notes+1] = copy_table(self.ability.future_notes[1])
			if self.ability.notes[#self.ability.notes].type >= 10 then
				self.ability.notes[#self.ability.notes].y = self.ability.notes[#self.ability.notes].y * DY * self.ability.note_speed
				for index, value in ipairs(self.ability.notes[#self.ability.notes].left) do
					if index % 2 == 0 then
						self.ability.notes[#self.ability.notes].left[index] = value * DY * self.ability.note_speed
					else
						self.ability.notes[#self.ability.notes].left[index] = width * (1 - BAR_WIDTH) / 2 + ((value - 1) * width * BAR_WIDTH / #self.ability.highlights)
					end
				end
				for index, value in ipairs(self.ability.notes[#self.ability.notes].right) do
					if index % 2 == 0 then
						self.ability.notes[#self.ability.notes].right[index] = value * DY * self.ability.note_speed
					else
						self.ability.notes[#self.ability.notes].right[index] = width * (1 - BAR_WIDTH) / 2 + ((value - 1) * width * BAR_WIDTH / #self.ability.highlights)
					end
				end
			end
			table.remove(self.ability.future_notes, 1)
		end

		-- hp easing
		self.ability.health = math.floor(self.ability.health + (self.ability.ease_health - self.ability.health) * 0.1)

		-- end the song if all notes are gone
		if #self.ability.future_notes == 0 and #self.ability.notes == 0 then
			self.ability.state = self.ability.states.CLEAR
			self.ability.best_combo = math.max(self.ability.best_combo, self.ability.current_combo)
		end
	end,
	miss_note = function(self, i)
		self.ability.miss = self.ability.miss + 1
		self.ability.best_combo = math.max(self.ability.best_combo, self.ability.current_combo)
		self.ability.current_combo = 0
		self.ability.ease_health = math.max(0, self.ability.ease_health - 100)
		table.remove(self.ability.notes, i)
		print("miss")
	end,
	bad_note = function(self, i)
		self.ability.bad = self.ability.bad + 1
		self.ability.best_combo = math.max(self.ability.best_combo, self.ability.current_combo)
		self.ability.current_combo = 0
		self.ability.ease_health = math.max(0, self.ability.ease_health - 50)
		table.remove(self.ability.notes, i)
		print("bad")
	end,
	good_note = function(self, i)
		self.ability.good = self.ability.good + 1
		self.ability.best_combo = math.max(self.ability.best_combo, self.ability.current_combo)
		self.ability.current_combo = 0
		table.remove(self.ability.notes, i)
		print("good")
	end,
	great_note = function(self, i)
		self.ability.great = self.ability.great + 1
		self.ability.current_combo = self.ability.current_combo + 1
		table.remove(self.ability.notes, i)
		print("great")
	end,
	perfect_note = function(self, i)
		self.ability.perfect = self.ability.perfect + 1
		self.ability.current_combo = self.ability.current_combo + 1
		table.remove(self.ability.notes, i)
		print("perfect")
	end,
	love_draw = function(self)
		if self.ability.state == self.ability.states.GAMEPLAY or self.ability.state == self.ability.states.CARD or self.ability.state == self.ability.states.CLEAR then
			self:draw_gameplay()
		end
		if self.ability.state == self.ability.states.CARD then
			self:draw_title()
		end
		if self.ability.state == self.ability.states.CLEAR then
			self:draw_clear()
		end
		if self.ability.state == self.ability.states.MESSAGE then
			self:draw_message()
		end
		if self.ability.state == self.ability.states.RESULTS then
			self:draw_results()
		end
	end,
	draw_results = function(self)
		if self.ability.results_ui then
			local cover_UIE = self.ability.results_ui:get_UIE_by_ID("chart_cover")
			if cover_UIE then
				local SPRITE_DIM = 300
				local transform = cover_UIE.VT
				local w = transform.w / SPRITE_DIM
				local h = transform.h / SPRITE_DIM
				love.graphics.push()
    		love.graphics.scale(G.TILESCALE*G.TILESIZE)
				love.graphics.translate( --- FIX THIS. TEMPORARY SOLUTION
					cover_UIE.VT.x + 1.4625 + ((cover_UIE.layered_parallax and cover_UIE.layered_parallax.x) or ((cover_UIE.parent and cover_UIE.parent.layered_parallax and cover_UIE.parent.layered_parallax.x)) or 0),
					cover_UIE.VT.y + 0.7 + ((cover_UIE.layered_parallax and cover_UIE.layered_parallax.y) or ((cover_UIE.parent and cover_UIE.parent.layered_parallax and cover_UIE.parent.layered_parallax.y)) or 0))
				love.graphics.setColor(1, 1, 1, 1)
				love.graphics.draw(self.ability.cover_image, 0, 0, 0, w, h)
				love.graphics.pop()
			end
		end
	end,
	draw_message = function(self)
		local width, height = love.graphics.getDimensions()
		local BAR_HEIGHT = 200
		local BAR_CY = 0.5
		local SCALE = 5

		local my_canvas = love.graphics.newCanvas(width, height)
    love.graphics.setCanvas(my_canvas)
    love.graphics.clear()

		love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
		love.graphics.rectangle("fill", 0, height * BAR_CY - BAR_HEIGHT / 2, width, BAR_HEIGHT)
		local msg = "SHOW CLEAR!"
		if self.ability.hp == 0 then
			msg = "SHOW FAILED!"
		end
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.printf(msg, 0, height / 2 - BAR_HEIGHT / 4, width / SCALE, "center", 0, SCALE, SCALE)
		
		love.graphics.setCanvas()
		love.graphics.setColor(1, 1, 1, math.min(1, self.ability.message_timer * 4))
		love.graphics.draw(my_canvas, 0, 0)
	end,
	draw_clear = function(self)
		local width, height = love.graphics.getDimensions()
		local BAR_HEIGHT = 200
		local BAR_CY = 0.5
		local SCALE = 5

		local my_canvas = love.graphics.newCanvas(width, height)
    love.graphics.setCanvas(my_canvas)
    love.graphics.clear()

		love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
		love.graphics.rectangle("fill", 0, height * BAR_CY - BAR_HEIGHT / 2, width, BAR_HEIGHT)
		local msg = "SHOW COMPLETE!"
		if self.ability.miss == 0 and self.ability.bad == 0 and self.ability.good == 0 then
			msg = "FULL COMBO!"
			if self.ability.great == 0 then
				msg = "ALL PERFECT!"
			end
		end
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.printf(msg, 0, height / 2 - BAR_HEIGHT / 4, width / SCALE, "center", 0, SCALE, SCALE)
		
		love.graphics.setCanvas()
		love.graphics.setColor(1, 1, 1, math.min(1, self.ability.clear_timer * 4))
		love.graphics.draw(my_canvas, 0, 0)
	end,
	draw_title = function(self)
		local width, height = love.graphics.getDimensions()
		local TIMER_DURATION = 5
		local TITLE_Y = 0.8
		local TITLE_HEIGHT = 150
		local TITLE_X_OFFSET = 150
		local TITLE_Y_OFFSET = 20
		local ARTISTS_Y_OFFSET = 95
		local COVER_X_OFFSET = 20
		local COVER_WIDTH = 110
		local COVER_HEIGHT = 110
		local ACTUAL_COVER_WIDTH = 300
		local ACTUAL_COVER_HEIGHT = 300

		local my_canvas = love.graphics.newCanvas(width, height)
    love.graphics.setCanvas(my_canvas)
    love.graphics.clear()

		love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
		love.graphics.rectangle("fill", 0, height * TITLE_Y, width, TITLE_HEIGHT)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(self.ability.cover_image, COVER_X_OFFSET, height * TITLE_Y + TITLE_Y_OFFSET, 0, COVER_WIDTH / ACTUAL_COVER_WIDTH, COVER_HEIGHT / ACTUAL_COVER_HEIGHT, 0, 0)
		love.graphics.print(self.ability.title, TITLE_X_OFFSET, height * TITLE_Y + TITLE_Y_OFFSET, 0, 3, 3, 0, 0)
		love.graphics.print(table.concat(self.ability.artists, ", "), TITLE_X_OFFSET, height * TITLE_Y + ARTISTS_Y_OFFSET, 0, 1.5, 1.5, 0, 0)

		love.graphics.setCanvas()
		love.graphics.setColor(1, 1, 1, self.ability.title_timer > TIMER_DURATION - 1 and TIMER_DURATION - self.ability.title_timer or 1)
		love.graphics.draw(my_canvas, 0, 0)
	end,
	draw_gameplay = function(self)
		local width, height = love.graphics.getDimensions()
		-- no magic numbers please
		local BAR_WIDTH = 0.45
		local BAR_HEIGHT = 50
		local BAR_Y = 0.8
		local BAR_THICKNESS = 10
		local MINIBAR_THICKNESS = 2

		love.graphics.setColor(0, 0, 0, 0.6)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

		local my_canvas = love.graphics.newCanvas(width, height)
		love.graphics.push()
    love.graphics.setCanvas(my_canvas)
    love.graphics.clear()
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setLineWidth(BAR_THICKNESS)
		love.graphics.line(width * (1 - BAR_WIDTH) / 2, height, width * (1 - BAR_WIDTH) / 2, 0)
		love.graphics.line(width * (1 + BAR_WIDTH) / 2, height, width * (1 + BAR_WIDTH) / 2, 0)
		love.graphics.line(width * (1 - BAR_WIDTH) / 2, height * BAR_Y, width * (1 + BAR_WIDTH) / 2, height * BAR_Y)
		love.graphics.line(width * (1 - BAR_WIDTH) / 2, height * BAR_Y + BAR_HEIGHT, width * (1 + BAR_WIDTH) / 2, height * BAR_Y + BAR_HEIGHT)
		love.graphics.setLineWidth(MINIBAR_THICKNESS)
		for i=1,#self.ability.highlights - 1, 2 do
			love.graphics.line(width * (1 - BAR_WIDTH) / 2 + (i * width * BAR_WIDTH / #self.ability.highlights), height, width * (1 - BAR_WIDTH) / 2 + (i * width * BAR_WIDTH / #self.ability.highlights), 0)
		end
		love.graphics.setLineWidth(BAR_THICKNESS)
		for i=2,#self.ability.highlights - 1, 2 do
			love.graphics.line(width * (1 - BAR_WIDTH) / 2 + (i * width * BAR_WIDTH / #self.ability.highlights), height, width * (1 - BAR_WIDTH) / 2 + (i * width * BAR_WIDTH / #self.ability.highlights), 0)
		end
		for i=1,#self.ability.highlights do
			if self.ability.highlights[i] > 0 then
				love.graphics.setColor(0.8, 0.6, 0.7, 0.75 * self.ability.highlights[i])
				love.graphics.polygon("fill",
					width * (1 - BAR_WIDTH) / 2 + ((i - 1) * width * BAR_WIDTH / #self.ability.highlights), height,
					width * (1 - BAR_WIDTH) / 2 + (i * width * BAR_WIDTH / #self.ability.highlights), height,
					width * (1 - BAR_WIDTH) / 2 + (i * width * BAR_WIDTH / #self.ability.highlights), 0,
					width * (1 - BAR_WIDTH) / 2 + ((i - 1) * width * BAR_WIDTH / #self.ability.highlights), 0
				)
			end
		end
		local PRECISION = 3
		for _, note in ipairs(self.ability.notes) do
			if note.type == 1 then love.graphics.setColor(0.5, 1, 0.5, 1) -- normal tap
			elseif note.type == 2 then love.graphics.setColor(1, 1, 0.5, 1) -- yellow tap
			elseif note.type == 3 then love.graphics.setColor(0.5, 1, 0.5, 1) -- normal trace
			elseif note.type == 4 then love.graphics.setColor(1, 1, 0.5, 1) -- yellow trace
			elseif note.type == 6 then love.graphics.setColor(0.5, 1, 0.5, 1) -- normal slider start
			elseif note.type == 7 then love.graphics.setColor(1, 1, 0.5, 1) -- yellow slider start
			elseif note.type == 8 then love.graphics.setColor(0.5, 1, 0.5, 1) -- normal slider end
			elseif note.type == 9 then love.graphics.setColor(1, 1, 0.5, 1) -- yellow slider end
			elseif note.type == 10 then love.graphics.setColor(0.5, 1, 0.5, 0.7) -- normal slider hold
			elseif note.type == 11 then love.graphics.setColor(1, 1, 0.5, 0.7) -- yellow slider hold
			else love.graphics.setColor(1, 1, 1, 1) end -- this shouldn't appear
			if note.type <= 2 then love.graphics.rectangle("fill", width * (1 - BAR_WIDTH) / 2 + ((note.x - 1) * width * BAR_WIDTH / #self.ability.highlights), note.y, note.width * width * BAR_WIDTH / #self.ability.highlights, BAR_HEIGHT)
			elseif note.type <= 4 then love.graphics.rectangle("fill", width * (1 - BAR_WIDTH) / 2 + ((note.x - 1) * width * BAR_WIDTH / #self.ability.highlights), note.y + BAR_HEIGHT * 0.25, note.width * width * BAR_WIDTH / #self.ability.highlights, BAR_HEIGHT * 0.5)
			elseif note.type == 5 then -- invis trace notes for sliders
			elseif note.type <= 9 then love.graphics.rectangle("fill", width * (1 - BAR_WIDTH) / 2 + ((note.x - 1) * width * BAR_WIDTH / #self.ability.highlights), note.y, note.width * width * BAR_WIDTH / #self.ability.highlights, BAR_HEIGHT)
			elseif note.type <= 11 then
				local left_mod = copy_table(note.left)
				local right_mod = copy_table(note.right)
				local left = love.math.newBezierCurve(left_mod):render(PRECISION)
				local right = love.math.newBezierCurve(right_mod):render(PRECISION)
				for i = 1, #right do
					table.insert(left, right[i])
				end
				left[#left+1]=left[#left-1]
				left[#left+1]=left[#left-1]
				love.graphics.push()
				love.graphics.translate(0, note.y)
				love.graphics.polygon("fill", left)
				love.graphics.pop()
			end -- figure out how to make a curve
		end
  	love.graphics.setCanvas()
		love.graphics.pop()

		local my_taper = love.graphics.newShader("Mods/FooBar/assets/minigames/projectsekai/tapering_shader.fs")
		my_taper:send("taper_intensity", 0.4) -- arbitrary number
		love.graphics.setShader(my_taper)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(my_canvas, 0, 0)
		love.graphics.setShader()

		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.print(self.ability.current_combo or 0, width*0.9, height*0.45,0,5,5)
		love.graphics.print("HP: " .. (self.ability.health or 0), width*0.8, height*0.1,0,4,4)
	end,
	generate_results_ui = function(self)
  	local width = G.hand.T.w-2
		local clear_state = {}
		if self.ability.miss == 0 and self.ability.bad == 0 and self.ability.good == 0 then
			clear_state = {{n=G.UIT.T, config={text="FULL COMBO!",scale=0.75,color=G.C.UI.TEXT_LIGHT}}}
			if self.ability.great == 0 then
				clear_state = {{n=G.UIT.T, config={text="ALL PERFECT!",scale=0.75,color=G.C.UI.TEXT_LIGHT}}}
			end
		end
		local t = {n=G.UIT.ROOT, config = {align = 'tl', colour = G.C.GREY, minh = 10, r = 0.15, padding = 0.15}, nodes={
			{n=G.UIT.R, config={align = "tm", minw = width, padding = 0.2, r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes={
				{n=G.UIT.R, config={align = "bl", minw = width}, nodes={
					{n=G.UIT.C, config={align="cm",minw=2,maxw=2,minh=2,maxh=2,colour=G.C.BLUE,id="chart_cover"}, nodes={
						{n=G.UIT.T, config={text="image here", scale=1, color=G.C.UI.TEXT_LIGHT}}
					}},
					{n=G.UIT.B, config={w=0.5,h=1}},
					{n=G.UIT.C, config={align="bl"}, nodes = {
						{n=G.UIT.R, config={align="bl"}, nodes = {
							{n=G.UIT.R, nodes = {
								{n=G.UIT.T, config={text=self.ability.title, scale=1, color=G.C.UI.TEXT_LIGHT}}
							}},
							{n=G.UIT.R, config={minh=0.1}, nodes = {
								{n=G.UIT.R, config={minh=0.1,minw=8,colour=G.C.UI.TEXT_INACTIVE}}
							}}
						}}
					}}
				}}
			}},
			{n=G.UIT.R, config={align = "cm", minh = 0.05}, nodes={}},
			{n=G.UIT.R, config={align = "cr", minh = 0.75}, nodes=clear_state},
			{n=G.UIT.R, config={align = "cm", minw = width}, nodes={
					{n=G.UIT.C, config={align="tl", minw=0.8*width, maxw=0.8*width}, nodes={
						{n=G.UIT.R, nodes={
							{n=G.UIT.T, config={text="Best Combo",scale=0.6,colour=G.C.UI.TEXT_LIGHT}}
						}},
						{n=G.UIT.R, nodes={
							{n=G.UIT.T, config={text="Perfect",scale=0.7,colour=G.C.UI.TEXT_LIGHT}}
						}},
						{n=G.UIT.R, nodes={
							{n=G.UIT.T, config={text="Great",scale=0.7,colour=G.C.UI.TEXT_LIGHT}}
						}},
						{n=G.UIT.R, nodes={
							{n=G.UIT.T, config={text="Good",scale=0.7,colour=G.C.UI.TEXT_LIGHT}}
						}},
						{n=G.UIT.R, nodes={
							{n=G.UIT.T, config={text="Bad",scale=0.7,colour=G.C.UI.TEXT_LIGHT}}
						}},
						{n=G.UIT.R, nodes={
							{n=G.UIT.T, config={text="Miss",scale=0.7,colour=G.C.UI.TEXT_LIGHT}}
						}}
					}},
					{n=G.UIT.C, config={align="tr", minw=0.2*width, maxw=0.2*width}, nodes={
						{n=G.UIT.R, nodes={
							{n=G.UIT.T, config={text=self.ability.best_combo,scale=0.6,colour=G.C.UI.TEXT_LIGHT}}
						}},
						{n=G.UIT.R, nodes={
							{n=G.UIT.T, config={text=self.ability.perfect,scale=0.7,colour=G.C.UI.TEXT_LIGHT}}
						}},
						{n=G.UIT.R, nodes={
							{n=G.UIT.T, config={text=self.ability.great,scale=0.7,colour=G.C.UI.TEXT_LIGHT}}
						}},
						{n=G.UIT.R, nodes={
							{n=G.UIT.T, config={text=self.ability.good,scale=0.7,colour=G.C.UI.TEXT_LIGHT}}
						}},
						{n=G.UIT.R, nodes={
							{n=G.UIT.T, config={text=self.ability.bad,scale=0.7,colour=G.C.UI.TEXT_LIGHT}}
						}},
						{n=G.UIT.R, nodes={
							{n=G.UIT.T, config={text=self.ability.miss,scale=0.7,colour=G.C.UI.TEXT_LIGHT}}
						}}
					}}
			}},
			{n=G.UIT.R, config={align = "cm", minh = 0.5,padding = 0.1, minw = width, r = 0.15, colour = G.C.ORANGE, shadow = true, hover = true, one_press = true, button = 'foobar_minigame_get_reward'}, nodes={
				{n=G.UIT.T, config={text="Continue!",scale=0.7,colour=G.C.UI.TEXT_LIGHT}}
			}},
		}}
		return t
	end,
	can_get_reward = function(self)
		return self.ability.health > 0 and self.ability.ease_health > 0
	end,
	cleanup = function(self, e)
		self.ability.results_ui:remove()
		self.ability.results_ui = nil
	end
}