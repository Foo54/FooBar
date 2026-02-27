if not CardSleeves then return nil end

local ref = CardSleeves.Sleeve.apply

CardSleeves.Sleeve{
	key = "bargain",
	atlas = "sleeves",
	pos = {x=0,y=0},
	config = {
		no_interest = true
	},
	loc_vars = function(self)
		local key, vars
		if self.get_current_deck_key() == "b_foobar_bargain" then
			key = self.key .. "_stacked"
			self.config = {
				no_interest = true,
				vouchers = {
					'v_reroll_surplus',
					'v_reroll_glut'
				}
			}
			vars = {localize { type = 'name_text', key = self.config.vouchers[1], set = 'Voucher' }, localize { type = 'name_text', key = self.config.vouchers[2], set = 'Voucher' }}
		else
			key = self.key
			self.config = {
				no_interest = true
			}
			vars = {1}
		end
		return {key = key, vars = vars}
	end,
	apply = function(self)
		ref(self)
		if self.get_current_deck_key() ~= "b_foobar_bargain" then
---@diagnostic disable-next-line: missing-parameter
			SMODS.Back:get_obj("b_foobar_bargain").apply(self)
		end
	end
}

CardSleeves.Sleeve{
	key = "adaptive",
	atlas = "sleeves",
	pos = {x=1,y=0},
	loc_vars = function(self)
		local key, vars
		if self.get_current_deck_key() == "b_foobar_adaptive" then
			key = self.key .. "_stacked"
			self.config = {
				vouchers = {
					'v_retcon',
					'v_directors_cut'
				}
			}
			vars = {localize { type = 'name_text', key = self.config.vouchers[1], set = 'Voucher' }, localize { type = 'name_text', key = self.config.vouchers[2], set = 'Voucher' }}
		else
			key = self.key
			self.config = nil
		end
		return {key = key, vars = vars}
	end,
	apply = function(self)
		ref(self)
		if self.get_current_deck_key() ~= "b_foobar_adaptive" then
---@diagnostic disable-next-line: missing-parameter
			SMODS.Back:get_obj("b_foobar_adaptive").apply(self)
		end
	end,
	calculate = function(self, card, context)
		if self.get_current_deck_key() ~= "b_foobar_adaptive" then
---@diagnostic disable-next-line: missing-parameter
			return SMODS.Back:get_obj("b_foobar_adaptive").calculate(self, card, context)
		end
	end
}