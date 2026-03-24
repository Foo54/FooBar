FooBar.Minigame{
	key="tetobaguettecatch",
	tag_pos = {x=1,y=0},
	config = {
		baugettes = {},
		caught = {},
		timer = 0,

		teto_x = -100,
		teto_y = -100,
		teto_w = 50,
		teto_h = 100,
		teto_r = 0,
		teto_vx = 0,
		teto_vy = 0,

		dash = true,
		
		score = 0,

		state = 0,
		states = {
			GAME = 0,
			FINISH = 1
		},

		d = {{-1, 0}, {1, 0}, {0, -20}, {0, 5}, {}},
		keybinds = {{"left", "a"}, {"right", "d"}, {"up", "space", "w"}, {"down", "s"}},
		pressed = {false, false, false, false},
		override_pressed = {false, false, false, false}
	},
	love_update = function(self, dt)
		if G.SETTINGS.paused then return end
		dt = G and G.real_dt or dt
		if self.ability.state == self.ability.states.GAME then
			self:update_game(dt)
		end
	end,
	update_game = function(self, dt)
		self.ability.timer = self.ability.timer + dt
		
		local width, height = love.graphics.getDimensions()
		local LINE_Y = 0.9
		if self.ability.teto_x == -100 then
			self.ability.teto_x = width / 2
		end
		if self.ability.teto_y == -100 then
			self.ability.teto_y = height * LINE_Y - self.ability.teto_h
		end

		-- inputs
		for index, keys in ipairs(self.ability.keybinds) do
			local count = 0
			for _, key in ipairs(keys) do
				if love.keyboard.isDown(key) then
					if not self.ability.override_pressed[index] then
						self.ability.pressed[index] = true
						break
					end
				else
					self.ability.pressed[index] = false
					count = count + 1
				end
			end
			if count == #keys then
				self.ability.override_pressed[index] = false
			end
		end
		for index, value in ipairs(self.ability.pressed) do
			if value then
				self:move_teto(self.ability.d[index])
			end
		end
		
		-- baguettes
		local BAUGETTE_HEIGHT = 50
		if #self.ability.baugettes < 5 and math.random() < 0.2 then
			self.ability.baugettes[#self.ability.baugettes+1] = {x=math.random(0, width), y=0, yv=0, r=0}
		end
		for _, baugette in ipairs(self.ability.baugettes) do
			baugette.yv = baugette.yv + 0.2
			baugette.y = baugette.y + baugette.yv
			baugette.r = baugette.r + 5/66
		end
		for i=#self.ability.baugettes,1,-1 do
			if (self.ability.teto_x - self.ability.baugettes[i].x) ^ 2 + (self.ability.teto_y - self.ability.baugettes[i].y) ^ 2 <= (BAUGETTE_HEIGHT + self.ability.teto_h) ^ 2 / 4 then
				table.remove(self.ability.baugettes, i)
				self.ability.score = self.ability.score + 1
				break
			end
			if self.ability.baugettes[i].y >=height * LINE_Y then
				table.remove(self.ability.baugettes, i)
			end
		end

		-- gravity
		self.ability.teto_vy = self.ability.teto_vy + 0.5

		-- collision
		if self.ability.teto_y > height * LINE_Y - self.ability.teto_h then
			if self.ability.pressed[4]then
				if self.ability.teto_vx < 0 then
					self.ability.teto_vx = self.ability.teto_vx - self.ability.teto_vy / 2
				else
					self.ability.teto_vx = self.ability.teto_vx + self.ability.teto_vy / 2
				end
				if self.ability.pressed[3] then
					self.ability.teto_vy = -25
					self.ability.override_pressed[4] = true
				end
			end
			self.ability.teto_y = height * LINE_Y - self.ability.teto_h
			self.ability.teto_vy = math.min(self.ability.teto_vy, 0)
		end

		-- physics
		local PADDING = 50
		local FRICTION = -0.1
		self.ability.teto_vx = self.ability.teto_vx + FRICTION * self.ability.teto_vx
		self.ability.teto_x =  math.max(math.min(width - PADDING, self.ability.teto_x + self.ability.teto_vx), PADDING)
		self.ability.teto_y = self.ability.teto_y + self.ability.teto_vy
		if self.ability.teto_y < height * LINE_Y - self.ability.teto_h - 2 then
			local mul = 0
			if self.ability.pressed[1] then
				mul = -1
				if self.ability.pressed[2] then
					mul = 0
				end
			elseif self.ability.pressed[2] then
				mul = 1
			end
			self.ability.teto_r = self.ability.teto_r + 5/33 * mul
		else
			self.ability.teto_r = 0
		end

	end,
	move_teto = function(self, d)
		local dx, dy = d[1], d[2]
		local width, height = love.graphics.getDimensions()
		local LINE_Y = 0.9
		if dx ~= 0 then
			self.ability.teto_vx = self.ability.teto_vx + dx
		end
		if dy ~= 0 then
			if math.abs(self.ability.teto_y - height * LINE_Y + self.ability.teto_h) <= 2 then
				if dy < 0 then
					self.ability.teto_vy = self.ability.teto_vy + dy
				end
			elseif dy > 0 then
				self.ability.teto_vy = self.ability.teto_vy + dy
			end
		end
	end,
	love_draw = function(self)
		if self.ability.state == self.ability.states.GAME then
			self:draw_game()
		end
	end,
	draw_game = function(self)
		local width, height = love.graphics.getDimensions()
		local LINE_Y = 0.9

		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setLineWidth(5)
		love.graphics.line(0, height * LINE_Y, width, height * LINE_Y)

		love.graphics.push()
		love.graphics.setColor(1, 0.1, 0.1, 1)
		love.graphics.translate(self.ability.teto_x + self.ability.teto_w / 2, self.ability.teto_y + self.ability.teto_h / 2)
		love.graphics.rotate(self.ability.teto_r)
		love.graphics.translate(-self.ability.teto_w / 2, -self.ability.teto_h / 2)
		love.graphics.rectangle("fill", 0, 0, self.ability.teto_w, self.ability.teto_h)
		love.graphics.pop()

		local BAUGETTE_WIDTH = 10
		local BAUGETTE_HEIGHT = 50
		for _, baugette in ipairs(self.ability.baugettes) do
			love.graphics.push()
			love.graphics.setColor(0.7, 0.7, 0, 1) -- bread color idk i'm guessing
			love.graphics.translate(baugette.x, baugette.y)
			love.graphics.rotate(baugette.r)
			love.graphics.rectangle("fill", -BAUGETTE_WIDTH/2, -BAUGETTE_HEIGHT/2, BAUGETTE_WIDTH, BAUGETTE_HEIGHT)
			love.graphics.pop()
		end

		love.graphics.setColor(1, 1, 1, 0.5)
		love.graphics.print(self.ability.score, width/2, height/2, 0, 8, 8)
	end,
	can_get_reward = function(self) return true end
}