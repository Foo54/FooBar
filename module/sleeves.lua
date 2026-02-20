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
			SMODS.Back:get_obj("b_foobar_bargain").apply(self)
		end
	end
}