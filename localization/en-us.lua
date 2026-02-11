return {
	descriptions = {
		Joker = {
			j_foobar_welcomenewmember = {
				name = "welcome new member",
				text = {
					"{C:chips}+#1#{} chips for each",
					"card above {C:attention}#2#{}",
					"in your deck",
					"{C:inactive}[Currently {C:chips}+#3#{C:inactive} Chips]"
				}
			},
			j_foobar_cannibalism = {
				name = "Cannibalism",
				text = {
					"after scoring",
					"eat played {C:attention}face{} cards",
					"and gain {C:mult}+#1#{} mult",
					"per card eaten",
					"Loses {C:mult}+#1#{} mult per hand",
					"if no {C:attention}face{} cards",
					"are scored",
					"{C:inactive}[Currently {C:mult}+#2#{C:inactive} Mult]"
				}
			},
			j_foobar_menace = {
				name = "Menace",
				text = {
					"{C:purple}Purple{} seals act as",
					"{C:gold}Gold{}, {C:blue}Blue{}, and {C:red}Red{} seals"
				},
			},
			j_foobar_firestarter = {
				name = "Firestarter",
				text = {
					"Gives {X:mult,C:white}X#1#{} mult",
					"{C:red,E:2}self destructs{} in {C:attention}#2#{} hands#<s>2#",
					"Only decrease timer if",
					"played hand exceeds",
					"blind requirement"
				}
			},
			j_foobar_flstudio = {
				name = "FL Studio",
				text = {
					{
						"Gives {X:mult,C:white}X#1#{} mult per {C:attention}producer{} joker",
						"{C:inactive}[Currently {X:mult,C:white}X#2#{C:inactive} Mult]"
					},
					{
						"Gives {C:money}$#3#{} per {C:attention}music{} joker",
						"at end of round",
						"{C:inactive}[Currently {C:money}$#4#{C:inactive}]"
					}
				}
			}
		}
	}
}