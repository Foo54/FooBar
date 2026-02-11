--Utility function to check things without erroring | copied from cryptid
---@param t table
---@param ... any
---@return table|false
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