--- UI code for blind select, collection, and minigame rewards
G.FUNCS.foobar_select_minigame = function(e)
	stop_use()
	G.CONTROLLER.locks.foobar_select_minigame = true
	G.E_MANAGER:add_event(Event({
			no_delete = true,
			trigger = 'after',
			blocking = false,blockable = false,
			delay = 2.5,
			timer = 'TOTAL',
			func = function()
				G.CONTROLLER.locks.foobar_select_minigame = nil
				return true
			end
		}))
	local _minigame = e.UIBox:get_UIE_by_ID('minigame_container')
	if _minigame then 
		local skipped, skip_to = G.GAME.blind_on_deck or 'Small', 
		G.GAME.blind_on_deck == 'Small' and 'Big' or G.GAME.blind_on_deck == 'Big' and 'Boss' or 'Boss'
		G.GAME.foobar_current_minigame = (G.GAME.round_resets.foobar_minigames or {[skipped] = FooBar.get_next_minigame_key()})[skipped]
		G.GAME.round_resets.blind_states[skipped] = 'Skipped'
		G.GAME.round_resets.blind_states[skip_to] = 'Select'
		G.GAME.blind_on_deck = skip_to
		play_sound('generic1')
		G.E_MANAGER:add_event(Event({
			trigger = 'immediate',
			func = function()
				delay(0.3)
        G.blind_prompt_box:get_UIE_by_ID('prompt_dynatext1').config.object.pop_delay = 0
        G.blind_prompt_box:get_UIE_by_ID('prompt_dynatext1').config.object:pop_out(5)
        G.blind_prompt_box:get_UIE_by_ID('prompt_dynatext2').config.object.pop_delay = 0
        G.blind_prompt_box:get_UIE_by_ID('prompt_dynatext2').config.object:pop_out(5)

        G.E_MANAGER:add_event(Event({
          trigger = 'before', delay = 0.2,
          func = function()
            G.blind_prompt_box.alignment.offset.y = -10
            G.blind_select.alignment.offset.y = 40
            G.blind_select.alignment.offset.x = 0
            return true
        end}))
        G.E_MANAGER:add_event(Event({
          trigger = 'immediate',
          func = function()
            G.blind_select:remove()
            G.blind_prompt_box:remove()
            G.blind_select = nil
            delay(0.2)
            return true
        end}))
        G.E_MANAGER:add_event(Event({
          trigger = 'immediate',
          func = function()
            delay(0.4)

            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    G.STATE = G.STATES.FOOBAR_MINIGAME
                    G.STATE_COMPLETE = false
										save_run()
                    return true
                end
            }))
            return true
          end
        }))
				return true
			end
		}))
	end
end

G.FUNCS.hover_minigame_proxy = function(e)
  if not e.parent or not e.parent.states then return end
  if (e.states.hover.is or e.parent.states.hover.is) and (e.created_on_pause == G.SETTINGS.paused) and
    not e.parent.children.alert then
      local _sprite = e.config.ref_table:get_uibox_table()
      e.parent.children.alert = UIBox{
        definition = G.UIDEF.card_h_popup(_sprite),
        config = {align="tm", offset = {x = 0, y = -0.1},
        major = e.parent,
        instance_type = 'POPUP'},
    }
    _sprite:juice_up(0.05, 0.02)
    play_sound('paper1', math.random()*0.1 + 0.55, 0.42)
    play_sound('tarot2', math.random()*0.1 + 0.55, 0.09)
    e.parent.children.alert.states.collide.can = false
  elseif e.parent.children.alert and
  ((not e.states.collide.is and not e.parent.states.collide.is) or (e.created_on_pause ~= G.SETTINGS.paused)) then
    e.parent.children.alert:remove()
    e.parent.children.alert = nil
  end
end

function G.UIDEF.foobar_minigame()
	local nodes = G.FOOBAR_MINIGAMES[G.GAME.foobar_current_minigame]:generate_gameplay_ui()
  if not nodes then return {n=G.UIT.ROOT, config = {align = 'tm', colour = G.C.CLEAR, r = 0.15, padding = 0.15}} end
	local t = {n=G.UIT.ROOT, config = {align = 'cm', colour = G.C.CLEAR, r = 0.15, padding = 0.15}, nodes={
		{n=G.UIT.R, config={align = "cm", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
			{n=G.UIT.R, config={align = "cm"}, nodes={
			{n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
				{n=G.UIT.C, config={align = "cm", r=0.2, shadow = true}, nodes=nodes}
			}}
		}}
    }}
  }}
  return t
end

function G:update_foobar_minigame(dt)
	if not G.STATE_COMPLETE then
		stop_use()
		ease_background_colour_blind(G.STATES.SHOP)
		G.FOOBAR_MINIGAMES[G.GAME.foobar_current_minigame]:set_ability()
		G.foobar_minigame = UIBox{
			definition = G.UIDEF.foobar_minigame(),
			config = {align='cmi', offset = {x=0,y=0}, major=G.ROOM_ATTACH, type="room", bond = 'Weak', instance_type="NODE"}
		}
    G.FOOBAR_MINIGAMES[G.GAME.foobar_current_minigame]:post_ui_creation()
		G.GAME.FOOBAR_MINIGAME = true
		G.STATE_COMPLETE = true
	end
end