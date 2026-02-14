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
					"{C:red,E:2}self destructs{} in {C:attention}#2#{} hand(s)",
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
						"Gives {C:money}$#3#{} per {C:attention}song{} joker",
						"at end of round",
						"{C:inactive}[Currently {C:money}$#4#{C:inactive}]"
					}
				}
			},
			j_foobar_retrynow = {
				name = "Retry Now",
				text = {
					{
						"Gives {X:mult,C:white}X#1#{} mult"
					},
					{
						"Prevents Death if chips scored",
						"are at least {C:attention}#1#%{} of required chips",
						'{C:red,E:2}self destructs{}, but will appear in the next shop',
						"at {C:red}double{} the cost and stats"
					}
				}
			},
			j_foobar_lostmedia = {
				name = "Lost Media",
				text = {
					"When {C:attention}glass{} cards are scored",
					"Increase the cards {X:mult,C:white}multiplier{}",
					"{C:green}numerator{}, and {C:green}denominator{} by {C:attention}#1#"
				}
			},
			j_foobar_kanadeyoisaki = {
				name = "Kanade Yoisaki",
				text = {
					"Gains {C:chips}+#1#{} chips",
					"When {C:attention}blind{} is selected",
					"{C:red}Resets{} when exiting shop",
					"if no jokers were bought",
					"{C:inactive}[Currently {C:chips}+#2#{C:inactive} chips]"
				}
			},
			j_foobar_nothing = {
				name = "Nothing",
				text = {
					"Gains {X:mult,C:white}X#1#{} mult",
					"when {C:attention}any card{} is {C:red}destroyed{}",
					"{C:inactive}[Currently {X:mult,C:white}X#2#{C:inactive} Mult]"
				}
			},
			j_foobar_enashinonome = {
				name = "Ena Shinonome",
				text = {
					"Gives {X:mult,C:white}X#1#{} mult",
					"per {C:attention}additional{} hand size.",
					"{C:inactive}[Currently {X:mult,C:white}X#2#{C:inactive} Mult]"
				}
			},
			j_foobar_mafuyuasahina = {
				name = "Mafuyu Asahina",
				text = {

				}
			}
		}
	}
}