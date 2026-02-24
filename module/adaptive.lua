---@diagnostic disable: param-type-mismatch
--- Code for the adaptive Deck
--- To implement your own blinds into this,
--- use the FooBar.registerAdaptiveEffect
--- 
--- 



--- Registers an effect for the adaptive deck.<br>
--- Key should be the blinds key,<br>
--- type should be either "calculate", "suit", "onetime", "draw",<br>
--- callback is the actual function that will do the effect, make sure you check for correct context<br>
--- Localization entries should be in Other and formatted as<br>
---  ba_{full blind key}<br>
---  Such as: ba_bl_hook or ba_bl_cry_joke<br>
--- Look in this file for examples
---@param key string
---@param type string
---@param callback function
function FooBar.registerAdaptiveEffect (key, type, callback)
	FooBar.adaptive.registeredBlinds[key] = {
		type = type,
		callback = callback
	}
end

local card_get_suit_ref = Card.is_suit
---@diagnostic disable-next-line: duplicate-set-field
function Card.is_suit (self, suit, bypass_debuff, flush_calc)
	local ret = card_get_suit_ref(self, suit, bypass_debuff, flush_calc)
	if ret then return ret end
	for blind, _ in pairs(G.GAME.foobar_adaptive.clearedBlinds.suit) do
		ret = ret or FooBar.adaptive.registeredBlinds[blind].callback(self, suit, bypass_debuff, flush_calc)
		if ret then return ret end
	end
	return ret
end

local cardarea_shuffle_ref = CardArea.shuffle
---@diagnostic disable-next-line: duplicate-set-field
function CardArea.shuffle (self, _seed)
	local ret = cardarea_shuffle_ref(self, _seed)
	if G.GAME.foobar_adaptive then
		for blind, _ in pairs(G.GAME.foobar_adaptive.clearedBlinds.draw) do
			FooBar.adaptive.registeredBlinds[blind].callback(self, _seed)
		end
		self:set_ranks() --- idk what this does but the original function has it and it seems important
	end
	return ret
end

if not FooBar.adaptive then
	FooBar.adaptive = {
		registeredBlinds = {}
	}
end

--- Vanilla Blind Implementation

FooBar.registerAdaptiveEffect(
	"bl_hook",
	"calculate",
	function (self, back, context)
		if context.before then
			local cards = {}
			while #G.hand.cards - #cards > 0 and #cards < 2 do
				cards[#cards + 1] = pseudorandom_element(G.hand.cards, "adaptive_hook")
				if #cards == 2 and cards[2] == cards[1] then
					cards[2] = nil
				end
			end
			for _, card in ipairs(cards) do
				card.ability.foobar_adaptive_hook = true
			end
		elseif context.repetition and context.cardarea == G.hand and context.other_card.ability.foobar_adaptive_hook then
			return {repetitions = 1}
		elseif context.after then
			for _, card in ipairs(G.hand.cards) do
				card.ability.foobar_adaptive_hook = nil
			end
		end
	end
)

FooBar.registerAdaptiveEffect(
	"bl_ox",
	"calculate",
	function (self, back, context)
		if context.before and context.scoring_name == G.GAME.current_round.most_played_poker_hand then
			return {dollars = 5}
		end
	end
)

FooBar.registerAdaptiveEffect(
	"bl_house",
	"calculate",
	function (self, back, context)
		if context.repetition and context.cardarea == G.play and G.GAME.current_round.hands_played == 0 then
			return {repetitions = 1}
		end
	end
)

FooBar.registerAdaptiveEffect(
	"bl_wall",
	"calculate",
	function (self, back, context)
		if context.final_scoring_step then
			return {xmult = 2}
		end
	end
)

FooBar.registerAdaptiveEffect(
	"bl_wheel",
	"calculate",
	function (self, back, context)
		if context.repetition then
			local flag = false
			if FooBar.average_probability() then
				if not G.GAME.foobar_adaptive.blindExtra.bl_wheel then G.GAME.foobar_adaptive.blindExtra.bl_wheel = {} end
				local num, dem = SMODS.get_probability_vars(back, 1, 7, "adaptive_wheel")
				G.GAME.foobar_adaptive.blindExtra.bl_wheel.counter = ((G.GAME.foobar_adaptive.blindExtra.bl_wheel.counter or 0) + 1) % dem
				if G.GAME.foobar_adaptive.blindExtra.bl_wheel.counter < num then
					flag = true
				end
			elseif SMODS.pseudorandom_probability(back, "adaptive_wheel", 1, 7) then flag = true end
			if flag then
				return {repetitions = 1}
			end
		end
	end
)

FooBar.registerAdaptiveEffect(
	"bl_arm",
	"calculate",
	function (self, back, context)
		if context.before then
			return {level_up = true}
		end
	end
)

FooBar.registerAdaptiveEffect(
	"bl_club",
	"suit",
	function (self, suit, bypass_debuff, flush_calc)
		if suit == "Clubs" then return true end
	end
)

FooBar.registerAdaptiveEffect(
	"bl_fish",
	"calculate",
	function (self, back, context)
		if context.first_hand_drawn then
			for _, card in ipairs(G.hand.cards) do
				card.ability.foobar_adaptive_fish = true
			end
		elseif context.repetition and not context.other_card.ability.foobar_adaptive_fish then
			return {repetitions = 1}
		elseif context.round_eval then
			for _, card in ipairs(G.deck.cards) do
				card.ability.foobar_adaptive_fish = nil
			end
		end
	end
)

FooBar.registerAdaptiveEffect(
	"bl_psychic",
	"calculate",
	function (self, back, context)
		if context.before then
			if not G.GAME.foobar_adaptive.blindExtra.bl_psychic then G.GAME.foobar_adaptive.blindExtra.bl_psychic = {} end
			G.GAME.foobar_adaptive.blindExtra.bl_psychic.ret = #context.scoring_hand == 5
		end
	end
)

local draw_from_play_to_discard_ref = G.FUNCS.draw_from_play_to_discard
---@diagnostic disable-next-line: duplicate-set-field
function G.FUNCS.draw_from_play_to_discard (e)
	if G.GAME.foobar_adaptive and G.GAME.foobar_adaptive.blindExtra.bl_psychic and G.GAME.foobar_adaptive.blindExtra.bl_psychic.ret then
		G.FUNCS.draw_from_play_to_hand(G.play.cards)
		return true
	end
	return draw_from_play_to_discard_ref(e)
end

FooBar.registerAdaptiveEffect(
	"bl_goad",
	"suit",
	function (self, suit, bypass_debuff, flush_calc)
		if suit == "Spades" then return true end
	end
)

FooBar.registerAdaptiveEffect(
	"bl_water",
	"onetime",
	function (self, deck, context)
		G.GAME.round_resets.discards = G.GAME.round_resets.discards + G.GAME.blind.discards_sub
		ease_discard(G.GAME.blind.discards_sub)
	end
)

FooBar.registerAdaptiveEffect(
	"bl_window",
	"suit",
	function (self, suit, bypass_debuff, flush_calc)
		if suit == "Diamonds" then return true end
	end
)

FooBar.registerAdaptiveEffect(
	"bl_manacle",
	"onetime",
	function (self, deck, context)
		G.hand:change_size(1)
	end
)

FooBar.registerAdaptiveEffect(
	"bl_eye",
	"calculate",
	function (self, back, context)
		if context.setting_blind then
			if not G.GAME.foobar_adaptive.blindExtra.bl_eye then G.GAME.foobar_adaptive.blindExtra.bl_eye = {} end
			G.GAME.foobar_adaptive.blindExtra.bl_eye.played = nil
		end
		if context.before then
			if not G.GAME.foobar_adaptive.blindExtra.bl_eye then G.GAME.foobar_adaptive.blindExtra.bl_eye = {} end
			if not G.GAME.foobar_adaptive.blindExtra.bl_eye.played then G.GAME.foobar_adaptive.blindExtra.bl_eye.played = context.scoring_name end
			if G.GAME.foobar_adaptive.blindExtra.bl_eye.played ~= context.scoring_name then
				G.GAME.foobar_adaptive.blindExtra.bl_eye.played = 1
				return {
					message = "Disabled Eye!"
				}
			end
		end
		if context.repetition and context.cardarea == G.play then
			if G.GAME.foobar_adaptive.blindExtra.bl_eye.played ~= 1 then
				return {
					repetitions = 1
				}
			end
		end
	end
)

FooBar.registerAdaptiveEffect(
	"bl_mouth",
	"calculate",
	function (self, back, context)
		if context.setting_blind then
			if not G.GAME.foobar_adaptive.blindExtra.bl_mouth then G.GAME.foobar_adaptive.blindExtra.bl_mouth = {} end
			G.GAME.foobar_adaptive.blindExtra.bl_mouth.played = {}
			G.GAME.foobar_adaptive.blindExtra.bl_mouth.disabled = false
		end
		if context.before then
			if not G.GAME.foobar_adaptive.blindExtra.bl_mouth then G.GAME.foobar_adaptive.blindExtra.bl_mouth = {played = {}, disabled = false} end
			if not G.GAME.foobar_adaptive.blindExtra.bl_mouth.disabled then
				for _, name in ipairs(G.GAME.foobar_adaptive.blindExtra.bl_mouth.played) do
					if name == context.scoring_name then
						G.GAME.foobar_adaptive.blindExtra.bl_mouth.disabled = true
						break
					end
				end
				if G.GAME.foobar_adaptive.blindExtra.bl_mouth.disabled then
					return {
						message = "Disabled Mouth!"
					}
				end
				G.GAME.foobar_adaptive.blindExtra.bl_mouth.played[#G.GAME.foobar_adaptive.blindExtra.bl_mouth.played + 1] = context.scoring_name
			end
		end
		if context.repetition and context.cardarea == G.play then
			if not G.GAME.foobar_adaptive.blindExtra.bl_mouth.disabled then
				return {
					repetitions = 1
				}
			end
		end
	end
)

FooBar.registerAdaptiveEffect(
	"bl_face",
	"calculate",
	function (self, back, context)
		if context.individual and context.other_card:is_face() then
			return {xmult = 1.25}
		end
	end
)

FooBar.registerAdaptiveEffect(
	"bl_serpent",
	"calculate",
	function (self, back, context)
		if context.drawing_cards and (G.GAME.current_round.hands_played ~= 0 or G.GAME.current_round.discards_used ~= 0) then
			return {
				cards_to_draw = math.max(context.amount, 3)
			}
		end
	end
)

FooBar.registerAdaptiveEffect(
	"bl_pillar",
	"draw",
	function(self, _seed)
		local moved = {}
		for i = 1, #self.cards do
			if not moved[self.cards[i]] then
				if self.cards[i].ability.played_this_ante then
					for j = #self.cards, i, -1 do
						if not self.cards[j].ability.played_this_ante then
							moved[self.cards[i]] = true
							self.cards[i], self.cards[j] = self.cards[j], self.cards[i]
							break
						end
					end
				end
			end
		end
	end
)

FooBar.registerAdaptiveEffect(
	"bl_needle",
	"onetime",
	function (self, deck, context)
		G.GAME.round_resets.hands = G.GAME.round_resets.hands + G.GAME.blind.hands_sub
		ease_hands_played(G.GAME.blind.hands_sub)
	end
)

FooBar.registerAdaptiveEffect(
	"bl_head",
	"suit",
	function (self, suit, bypass_debuff, flush_calc)
		if suit == "Hearts" then return true end
	end
)

FooBar.registerAdaptiveEffect(
	"bl_tooth",
	"calculate",
	function (self, deck, context)
		if context.press_play then
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.2,
				func = function()
					for i = 1, #G.play.cards do
						G.E_MANAGER:add_event(Event({
							func = function()
								G.play.cards[i]:juice_up()
								return true
							end,
						}))
						ease_dollars(1)
						delay(0.23)
					end
					return true
				end
			}))
		end
	end
)

FooBar.registerAdaptiveEffect(
	"bl_flint",
	"calculate",
	function (self, deck, context)
		if context.modify_hand then
			_G.mult = mod_mult(_G.mult * 2)
			_G.hand_chips = mod_chips(_G.hand_chips * 2)
			update_hand_text({ sound = 'chips2', modded = true }, { chips = _G.hand_chips, mult = _G.mult })
		end
	end
)

FooBar.registerAdaptiveEffect(
	"bl_mark",
	"calculate",
	function (self, deck, context)
		if context.repetition and context.other_card:is_face() then
			return {
				repetitions = 1
			}
		end
	end
)

FooBar.registerAdaptiveEffect(
	"bl_final_acorn",
	"onetime",
	function(self, deck, context)
		print("Hey this doesn't do anything cuase I have no idea what to do...")
	end
)

FooBar.registerAdaptiveEffect(
	"bl_final_leaf",
	"onetime",
	function (self, deck, context)
		G.jokers.config.card_limit = G.jokers.config.card_limit + 1
	end
)

FooBar.registerAdaptiveEffect(
	"bl_final_vessel",
	"calculate",
	function (self, back, context)
		if context.final_scoring_step then
			return {xmult = 3}
		end
	end
)

FooBar.registerAdaptiveEffect(
	"bl_final_heart",
	"calculate",
	function (self, back, context)
		if context.before then
			local card = pseudorandom_element(G.jokers.cards, "adaptive_heart")
			card.ability.foobar_blfinalheart = true
		end
		if context.after then
			for index, card in ipairs(G.jokers.cards) do
				card.ability.foobar_blfinalheart = nil
			end
		end
	end
)
SMODS.Sticker{
	key = "blfinalheart",
	loc_txt = {
		name = "Hearted",
		label = "Hearted",
		text = {
			"Copies ability of",
			"joker to the right"
		}
	},
	badge_colour = HEX("cc3333"),
	calculate = function(self, card, context)
		local other_joker = nil
		for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then other_joker = G.jokers.cards[i + 1] end
		end
		local ret = SMODS.blueprint_effect(card, other_joker, context)
		if ret then
				ret.colour = G.C.RED
		end
		return ret
	end
}

FooBar.registerAdaptiveEffect(
	"bl_final_bell",
	"calculate",
	function (self, deck, context)
		if context.hand_drawn then
			local card = pseudorandom_element(G.hand.cards, "adaptive_bell_card")
			if card then
				if not next(SMODS.get_enhancements(card)) then
					card:set_ability(pseudorandom_element(G.P_CENTER_POOLS["Enhanced"], "adaptive_bell_enhancement").key)
				elseif not card.seal then
					card:set_seal(SMODS.poll_seal{guaranteed=true, seed="adaptive_bell_seal"})
				elseif not card.edition then
					card:set_edition(SMODS.poll_edition{guaranteed=true, seed="adaptive_bell_edition"})
				else
					card.ability.perma_bonus = (card.ability.perma_bonus or 0) + 10
				end
			end
		end
	end
)


SMODS.Back{
	key = "adaptive",
	atlas = "decks",
	pos = { x = 1, y = 0 },
	apply = function(self)
		G.GAME.foobar_adaptive = {
			blindExtra = {},
			clearedBlinds = {
				calculate = {},
				suit = {},
				modifier = {},
				draw = {},
				onetime = {}
			}
		}
	end,
	calculate = function (self, back, context)
		if context.end_of_round and context.game_over == false and context.main_eval and context.beat_boss then
			if not G.GAME.blind.disabled then
				local state, msg = pcall(function()
					local key = G.GAME.blind.config.blind.key
					local type = FooBar.adaptive.registeredBlinds[key].type
					G.GAME.foobar_adaptive.clearedBlinds[type][key] = true
					if type == "onetime" then
						FooBar.adaptive.registeredBlinds[key].callback(self, back, context)
					end
				end)
				if not state then
					print(msg)
					print("If this is a nil index issue, you likely gave the incorrect key")
				else
					return {
						message = "Upgrade!"
					}
				end
			end
		end
		local ret = {}
		for blind, _ in pairs(G.GAME.foobar_adaptive.clearedBlinds.calculate) do
			ret[#ret + 1] = FooBar.adaptive.registeredBlinds[blind].callback(self, back, context)
		end
		return SMODS.merge_effects(ret)
	end
}

--- Generate Bonus tab UI

function G.UIDEF.foobar_view_bonuses ()
	local ret = {n = G.UIT.ROOT, config = {align = "cm", minw = 3, padding = 0.1, r = 0.1, colour = G.C.CLEAR}, nodes = {
		{n = G.UIT.C, nodes = {}}
	}}
	local pushcol = function (r)
		r.nodes[1].nodes[#r.nodes[1].nodes + 1] = {n = G.UIT.C, config = {align = "tm"}, nodes = {}}
		return r
	end
	pushcol(ret)
	local row_limit = 5
	for _, set in pairs(G.GAME.foobar_adaptive.clearedBlinds) do
		for key, _ in pairs(set) do
			if #ret.nodes[1].nodes[#ret.nodes[1].nodes].nodes >= row_limit then ret = pushcol(ret) end
			local N = {}
			localize{type = "other", key = "ba_" .. key, nodes = N}
			local B = G.P_BLINDS[key]
			local out = {n = G.UIT.C, config = {colour = G.C.WHITE, maxw = 4, padding = 0.1, r = 0.1}, nodes = {
				{n = G.UIT.R, config = {colour = mix_colours(get_blind_main_colour(key), G.C.BLACK, 0.7), r = 0.1, padding = 0.1, align="cm"}, nodes = {
					{n = G.UIT.O, config = {object = SMODS.create_sprite(0, 0, 0.5, 0.5, SMODS.get_atlas(B.atlas) or 'blind_chips', B.pos)}},
					{n = G.UIT.T, config = {text = SMODS.Blind:get_obj(key).name or "ERROR", scale = 0.5, colour = G.C.WHITE}}
				}}
			}}
			for _, line in ipairs(N) do
				out.nodes[#out.nodes + 1] = {n = G.UIT.R, nodes = line, config = {align = "cm"}}
			end
			-- Please don't do this
			-- this is not a good idea
			-- store references somewhere instead
			ret.nodes[1].nodes[#ret.nodes[1].nodes].nodes[#ret.nodes[1].nodes[#ret.nodes[1].nodes].nodes + 1] = {n = G.UIT.R, nodes = {out}, config={align="tm", r=0.2, padding=0.1}}
		end
	end
	return ret
end

