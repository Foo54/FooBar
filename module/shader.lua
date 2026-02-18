if SMODS.ScreenShader then
SMODS.ScreenShader{
	key = "menaceshader",
	path = "menace.fs",
	should_apply = function(self)
		return next(SMODS.find_card("j_foobar_menace"))
	end,
}
end