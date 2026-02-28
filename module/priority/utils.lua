---@diagnostic disable: redundant-parameter
--Utility function to check things without erroring | copied from cryptid
---@param t table
---@param ... any
---@return any
function FooBar.safe_get(t, ...)
	local current = t
	for _, k in ipairs({ ... }) do
		if not current or current[k] == nil then
			return false
		end
		current = current[k]
	end
	return current
end

--Utility function to check things without erroring | copied from cryptid
---@param t table
---@param ta table
---@return table|false
function FooBar.safe_get_table(t, ta)
	local current = t
	for _, k in ipairs(ta) do
		if not current or current[k] == nil then
			return false
		end
		current = current[k]
	end
	return current
end

function FooBar.filter_by_pool (cards, pool)
	local ret = {}
	for key, c in pairs(cards) do
		local pools = FooBar.safe_get(c, "config", "center", "pools")
		if pools and pools[pool] then
			ret[#ret + 1] = c
		end
	end
	return ret
end

function FooBar.average_probability ()
	local card = SMODS.find_card("j_foobar_simplex")[1]
	return card and not card.debuff
end

-- Utility function for generating take_ownership calculate effects for jokers that do something every n triggers
---@param key string
---@param condition function
---@param num_table table
---@param dem_table table
---@param effect function
---@return function
function FooBar.generate_average_probability_func_nth_trigger (key, condition, num_table, dem_table, effect)
	local ref_card = SMODS.Joker:get_obj(key).calculate or function() end
	return function(self, card, context)
		if condition(self, card, context) and FooBar.average_probability() then
			local num, dem = SMODS.get_probability_vars(card, FooBar.safe_get_table(card.ability, num_table) or 1, FooBar.safe_get_table(card.ability, dem_table) or 2, key)
			card.ability.foobar_counter = ((card.ability.foobar_counter or -1) + 1) % dem
			if card.ability.foobar_counter < num then
				return effect(self, card, context)
			else
				return {}
			end
		end
		return ref_card(self, card, context)
	end
end

-- Utility function for generating loc_vars effects for jokers that do something every n triggers
---@param key string
---@param num_table table
---@param dem_table table
---@param loc_vars_key string
---@param loc_vars_table table|nil
---@return function
function FooBar.generate_average_probability_nth_trigger_loc_vars (key, num_table, dem_table, loc_vars_key, loc_vars_table)
	local ref_card = SMODS.Joker:get_obj(key).loc_vars or function() end
	return function(self, info_queue, card)
		if FooBar.average_probability() then
			local num, dem = SMODS.get_probability_vars(card, FooBar.safe_get_table(card.ability, num_table) or 1, FooBar.safe_get_table(card.ability, dem_table) or 2, key)
			local ret = {num, dem, (card.ability.foobar_counter or 0) + 1}
			for i, v in ipairs(loc_vars_table or {}) do
---@diagnostic disable-next-line: assign-type-mismatch, param-type-mismatch
				ret[#ret + 1] = FooBar.safe_get_table(card.ability, loc_vars_table)
			end
			return {key = loc_vars_key, vars = ret}
		end
		return ref_card(self, info_queue, card)
	end
end


-- Utility function for calling take_ownership for jokers that do something every n triggers
---@param key string
---@param condition function
---@param num_table table
---@param dem_table table
---@param effect function
---@param loc_vars_key string
---@param loc_vars_table table|nil
function FooBar.take_ownership_nth_trigger (key, condition, num_table, dem_table, effect, loc_vars_key, loc_vars_table)
	SMODS.Joker:take_ownership(key, {
		calculate = FooBar.generate_average_probability_func_nth_trigger("j_" .. key, condition, num_table, dem_table, effect),
		loc_vars = FooBar.generate_average_probability_nth_trigger_loc_vars("j_" .. key, num_table, dem_table, loc_vars_key, loc_vars_table),
	}, true)
end
	
-- Utility function for generating take_ownership calculate effects for jokers have an expected value
---@param key string
---@param condition function
---@param num_table table
---@param dem_table table
---@param fail table
---@param succeed table
---@return function
function FooBar.generate_average_probability_func_expected_value (key, condition, num_table, dem_table, fail, succeed)
	local ref_card = SMODS.Joker:get_obj(key).calculate or function() end
	return function(self, card, context)
		if condition(self, card, context) and FooBar.average_probability() then
			local ret = {}
			for index, value in ipairs(dem_table) do
				local num, dem = SMODS.get_probability_vars(card, FooBar.safe_get_table(card.ability, num_table[index]) or 1, FooBar.safe_get_table(card.ability, dem_table[index]) or 2, key)
				num = math.min(dem, num)
				local suc, fal = succeed[index].value, fail[index].value
				if suc == nil then suc = FooBar.safe_get_table(card.ability, succeed[index].path) end
				if fal == nil then fal = FooBar.safe_get_table(card.ability, fail[index].path) end
				local v = (num * suc + (dem - num) * fal) / dem
				ret[succeed[index].key] = v
			end
			return ret
		end
		return ref_card(self, card, context)
	end
end

-- Utility function for generating loc_vars effects for jokers that do something every n triggers
---@param key string
---@param num_table table
---@param dem_table table
---@param fail table
---@param succeed table
---@param loc_vars_key string
---@param loc_vars_table table|nil
---@return function
function FooBar.generate_average_probability_expected_value_loc_vars (key, num_table, dem_table, fail, succeed, loc_vars_key, loc_vars_table)
	local ref_card = SMODS.Joker:get_obj(key).loc_vars or function() end
	return function(self, info_queue, card)
		if FooBar.average_probability() then
			local ret = {}
			for index, value in ipairs(dem_table) do
				local num, dem = SMODS.get_probability_vars(card, FooBar.safe_get_table(card.ability, num_table[index]) or 1, FooBar.safe_get_table(card.ability, dem_table[index]) or 2, key)
				num = math.min(dem, num)
				local suc, fal = succeed[index].value, fail[index].value
				if suc == nil then suc = FooBar.safe_get_table(card.ability, succeed[index].path) end
				if fal == nil then fal = FooBar.safe_get_table(card.ability, fail[index].path) end
				local v = (num * suc + (dem - num) * fal) / dem
				ret[#ret + 1] = v
			end
			for i, v in ipairs(loc_vars_table or {}) do
---@diagnostic disable-next-line: param-type-mismatch
				ret[#ret + 1] = FooBar.safe_get_table(card.ability, loc_vars_table)
			end
			return {key = loc_vars_key, vars = ret}
		end
		return ref_card(self, info_queue, card)
	end
end

-- Utility function for calling take_ownership for jokers that have an expected value
---@param key string
---@param condition function
---@param num_table table
---@param dem_table table
---@param fail table
---@param succeed table
---@param loc_vars_key string
---@param loc_vars_table table|nil
function FooBar.take_ownership_expected_value (key, condition, num_table, dem_table, fail, succeed, loc_vars_key, loc_vars_table)
	SMODS.Joker:take_ownership(key, {
		calculate = FooBar.generate_average_probability_func_expected_value("j_" .. key, condition, num_table, dem_table, fail, succeed),
		loc_vars = FooBar.generate_average_probability_expected_value_loc_vars("j_" .. key, num_table, dem_table, fail, succeed, loc_vars_key, loc_vars_table),
	}, true)
end