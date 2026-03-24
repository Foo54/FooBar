
G.FOOBAR_MINIGAMES = {}
G.FOOBAR_MINIGAMES_KEYS = {}

---@class FooBar.Minigame
---@field key string key minigame will be accessed by.
---@field generate_gameplay_ui? fun(self: FooBar.Minigame): table returns nodes for the gameplay ui if it can be done with balatro ui
---@field post_ui_creation? fun(self: FooBar.Minigame) called after generate_gameplay_ui is called and ui is created
---@field tag_atlas? string atlas key for the tag display. defaults to base game tags
---@field tag_pos? table|{x: integer, y: integer} atlas position for the tag display
---@field love_update? fun(self: FooBar.Minigame, dt: number) hooked into the love.update function
---@field love_draw? fun(self: FooBar.Minigame) hooked into the love.draw function
---@field can_get_reward fun(self: FooBar.Minigame): boolean true if the player won the minigame, false otherwise
---@field config? table config table for stuff the game needs to store
---@field set_ability? fun(self: FooBar.Minigame) hooked into this classes set_ability function
---@field set? string change the way the text alert is handled. don't mess with this unless you know what your doing
---@field cleanup? fun(self: FooBar.Minigame, e: "UIElement") any UI cleanup you need to run. Only needed by minigames which render custom balatro ui outsude of generate_gameplay_ui
---@field get_reward? fun(self: FooBar.Minigame, e: "UIElement") creates the reward for beating the minigame. Defaults to PJSK's reward
FooBar.Minigame = setmetatable({}, {
	__call = function (self, o)
		return FooBar.Minigame.new(o)
	end
})
FooBar.Minigame.__index = FooBar.Minigame
function FooBar.Minigame.new(args)
	local instance = setmetatable({}, FooBar.Minigame)
	instance.generate_gameplay_ui = args.generate_gameplay_ui or function(self) end
	instance.post_ui_creation = args.post_ui_creation or function(self) end
	instance.key = "fbminigame_" .. SMODS.current_mod.prefix .. "_" .. args.key
	instance.tag_atlas = args.tag_atlas or "tags"
	instance.tag_pos = args.tag_pos or {x=0, y=0}
	instance.love_update = args.love_update or function(self, dt) end
	instance.love_draw = args.love_draw or function(self) end
	instance.config = copy_table(args.config or {})
	instance.ability = copy_table(args.config or {})
	instance.set = args.set or "Tag"
	instance.cleanup = args.cleanup or function(self, e) end
	instance.get_reward = args.get_reward or function(self, e)
		add_tag(Tag(G.GAME.round_resets.blind_tags[G.GAME.blind_on_deck == "Big" and 'Small' or "Big"], nil, G.GAME.blind_on_deck == "Big" and 'Small' or "Big"))
		add_tag(Tag(G.GAME.round_resets.blind_tags[G.GAME.blind_on_deck == "Big" and 'Small' or "Big"], nil, G.GAME.blind_on_deck == "Big" and 'Small' or "Big"))
		add_tag(Tag(G.GAME.round_resets.blind_tags[G.GAME.blind_on_deck == "Big" and 'Small' or "Big"], nil, G.GAME.blind_on_deck == "Big" and 'Small' or "Big"))
		add_tag(Tag(G.GAME.round_resets.blind_tags[G.GAME.blind_on_deck == "Big" and 'Small' or "Big"], nil, G.GAME.blind_on_deck == "Big" and 'Small' or "Big"))
		play_sound('generic1')
		G.E_MANAGER:add_event(Event({
			trigger = 'immediate',
			func = function()
				delay(0.3)
				for i = 1, #G.GAME.tags do
					G.GAME.tags[i]:apply_to_run({type = 'immediate'})
				end
				return true
			end
		}))
	end
	for key, value in pairs(args) do
		if instance[key] == nil then
			instance[key] = value
		end
	end
	if args.set_ability then
		local instance_set_ability_ref = instance.set_ability or function(self)end
		function instance:set_ability()
			instance_set_ability_ref(self)
			args.set_ability(self)
		end
	end

	local love_update_ref = love.update
	function love.update(dt)
		love_update_ref(dt)
		if G and G.GAME and G.GAME.foobar_current_minigame == instance.key and G.STATE == G.STATES.FOOBAR_MINIGAME then
			instance:love_update(dt)
		end
	end
	local love_draw_ref = love.draw
	function love.draw()
		love_draw_ref()
		if G and G.GAME and G.GAME.foobar_current_minigame == instance.key and G.STATE == G.STATES.FOOBAR_MINIGAME and not G.OVERLAY_MENU then
			instance:love_draw()
		end
	end

	G.FOOBAR_MINIGAMES[instance.key] = instance
	table.insert(G.FOOBAR_MINIGAMES_KEYS, instance.key)
	return instance
end
function FooBar.Minigame:set_ability()
	self.ability = copy_table(self.config)
end
function FooBar.Minigame:init(_key)
	_key = _key or "fbminigame_foobar_projectsekai"
	local new = setmetatable({}, self)
	new.key = _key
	local proto = G.FOOBAR_MINIGAMES[_key]
	new.tag_atlas = proto.tag_atlas
	new.tag_pos = proto.tag_pos
	new:set_ability()
	return new
end
function FooBar.Minigame:generate_UI(_size)
	_size = _size or 0.8

	local tag_sprite_tab = nil

	local tag_sprite = SMODS.create_sprite(0, 0, _size*1, _size*1, SMODS.get_atlas(G.FOOBAR_MINIGAMES[self.key].tag_atlas), self.tag_pos)
	tag_sprite.T.scale = 1
	tag_sprite_tab = {n= G.UIT.C, config={align = "cm", ref_table = self}, nodes={
			{n=G.UIT.O, config={w=_size*1,h=_size*1, colour = G.C.BLUE, object = tag_sprite, focus_with_object = true}},
	}}
	tag_sprite:define_draw_steps({
			{shader = 'dissolve', shadow_height = 0.05},
			{shader = 'dissolve'},
	})
	tag_sprite.float = true
	tag_sprite.states.hover.can = true
	tag_sprite.states.drag.can = false
	tag_sprite.states.collide.can = true
	tag_sprite.config = {tag = self, force_focus = true}

	tag_sprite.hover = function(_self)
			if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then 
					if not _self.hovering and _self.states.visible then
							_self.hovering = true
							if _self == tag_sprite then
									_self.hover_tilt = 3
									_self:juice_up(0.05, 0.02)
									play_sound('paper1', math.random()*0.1 + 0.55, 0.42)
									play_sound('tarot2', math.random()*0.1 + 0.55, 0.09)
							end

							self:get_uibox_table(tag_sprite)
							_self.config.h_popup =  G.UIDEF.card_h_popup(_self)
							_self.config.h_popup_config = (_self.T.x > G.ROOM.T.w*0.4) and
									{align =  'cl', offset = {x=-0.1,y=0},parent = _self} or
									{align =  'cr', offset = {x=0.1,y=0},parent = _self}
							Node.hover(_self)
							if _self.children.alert then 
									_self.children.alert:remove()
									_self.children.alert = nil
									G:save_progress()
							end
					end
			end
	end
	tag_sprite.stop_hover = function(_self) _self.hovering = false; Node.stop_hover(_self); _self.hover_tilt = 0 end

	tag_sprite:juice_up()
	self.tag_sprite = tag_sprite

	return tag_sprite_tab, tag_sprite
end

function FooBar.Minigame:get_uibox_table(tag_sprite, vars_only)
	tag_sprite = tag_sprite or self.tag_sprite or {}
	tag_sprite.ability_UIBox_table = generate_card_ui(G.FOOBAR_MINIGAMES[self.key], nil, {}, 'Tag', nil, false, nil, nil, self)
	return tag_sprite
end

function FooBar.Minigame:generate_tag_ui()
end

function FooBar.Minigame:end_minigame(no_reward, e)
	if not no_reward then
		G.CONTROLLER.locks.skip_blind = true
		G.E_MANAGER:add_event(Event({
			no_delete = true,
			trigger = 'after',
			blocking = false,blockable = false,
			delay = 2.5,
			timer = 'TOTAL',
			func = function()
				G.CONTROLLER.locks.skip_blind = nil
				return true
			end
		}))
		G.E_MANAGER:add_event(Event({
			trigger = 'immediate',
			func = function()
				self:cleanup(e)
				G.foobar_minigame:remove()
				G.foobar_minigame = nil
				G.GAME.FOOBAR_MINIGAME = nil
				G.STATE = G.STATES.SHOP
				G.STATE_COMPLETE = false
				return true
			end
		}))
	else
		print("this isn't implemented yet ur just stuck")
	end
end

function FooBar.get_next_minigame_key()
	return G.FOOBAR_MINIGAMES_KEYS[2]
	--return pseudorandom_element(G.FOOBAR_MINIGAMES_KEYS, "foobar_minigame_choice")
end

function G.FUNCS.foobar_minigame_get_reward (e)
	if not G.foobar_minigame_practice and G.FOOBAR_MINIGAMES[G.GAME.foobar_current_minigame]:can_get_reward() then G.FOOBAR_MINIGAMES[G.GAME.foobar_current_minigame]:get_reward(e) end
	G.FOOBAR_MINIGAMES[G.GAME.foobar_current_minigame]:end_minigame(G.foobar_minigame_practice, e)
	G.E_MANAGER:add_event(Event({
		trigger="immediate",
		func=function()
			save_run()
			return true
		end
	}))
end
