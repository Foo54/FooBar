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
			j_foobar_nothing = {
				name = "Nothing",
				text = {
					"Gains {X:mult,C:white}X#1#{} mult",
					"when {C:attention}any card{} is {C:red}destroyed{}",
					"{C:inactive}[Currently {X:mult,C:white}X#2#{C:inactive} Mult]"
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
			j_foobar_kanadeyoisaki_miku = {
				name = "Kanade Yoisaki",
				text = {
					"Gains {C:chips}+#1#{} chips",
					"When {C:attention}blind{} is selected",
					"{C:inactive}[Currently {C:chips}+#2#{C:inactive} chips]"
				}
			},
			j_foobar_enashinonome = {
				name = "Ena Shinonome",
				text = {
					"Rerolling has a",
					"{C:green}#1# in #2# chance",
					"to create a {C:tarot}tarot{} card",
					"{C:inactive}(Must have room)"
				}
			},
			j_foobar_enashinonome_simplex = {
				name = "Ena Shinonome",
				text = {
					"The first {C:green}#1# of every #2#{} {C:attention}rerolls",
					"create a {C:tarot}tarot{} card",
					"{C:inactive}[Currently reroll {C:attention}#3#{C:inactive}]",
					"{C:inactive}(Must have room)"
				}
			},
			j_foobar_enashinonome_miku = {
				name = "Ena Shinonome",
				text = {
					"Rerolling has a",
					"{C:green}#1# in #2# chance",
					"to create a {C:tarot}tarot{} card"
				}
			},
			j_foobar_enashinonome_simplex_miku = {
				name = "Ena Shinonome",
				text = {
					"The first {C:green}#1# of every #2#{} {C:attention}rerolls",
					"create a {C:tarot}tarot{} card",
					"{C:inactive}[Currently reroll {C:attention}#3#{C:inactive}]"
				}
			},
			j_foobar_mafuyuasahina = {
				name = "Mafuyu Asahina",
				text = {
					"Scored cards give {C:chips}+#1#{} chips",
					"then lose {C:chips}#2#{} base chips {C:attention}permanently",
					"Cards with {C:chips}0{} base chips are {C:red}destroyed"
				} --- credits to Kusanehexaku for this idea
			},
			j_foobar_mafuyuasahina_miku = {
				name = "Mafuyu Asahina",
				text = {
					"Scored cards give {C:chips}+#1#{} chips"
				}
			},
			j_foobar_mizukiakiyama = {
				name = "Mizuki Akiyama",
				text = {
					"Gains {X:mult,C:white}X#1#{} when",
					"cards change {C:attention}enhancements",
					"Card must already have an {C:attention}enhancement",
					"{C:inactive}[Currently {X:mult,C:white}X#2#{C:inactive} Mult]"
				}
			},
			j_foobar_mizukiakiyama_miku = {
				name = "Mizuki Akiyama",
				text = {
					"Gains {X:mult,C:white}X#1#{} when",
					"cards change {C:attention}enhancements",
					"{C:inactive}[Currently {X:mult,C:white}X#2#{C:inactive} Mult]"
				}
			},
			j_foobar_hatsunemikun25 = {
				name = "Hatsune Miku (N25)",
				text = {
					"Removes all {C:red}negative{} effects from",
					"{V:1}Nightcord at 25:00{} cards"
				}
			},
			j_foobar_true = {
				name = "True",
				text = {
					"{X:mult,C:white}X#1#{} mult if", --# x3
					"cards played {C:attention}bitwise &'d{} together",
					"is greater than {C:attention}#2#{}" -- 0
				}
			},
			j_foobar_false = {
				name = "False",
				text = {
					"{X:mult,C:white}X#1#{} mult if",
					"cards played {C:attention}bitwise &'d{} together",
					"are {C:attention}#2#{}"
				}
			},
			j_foobar_simplex = {
				name = "Simplex Algorithm",
				text = {
					"{C:green}Probabilities{} are averaged out",
					"{C:green}1 in 2{C:inactive} for {X:mult,C:white}X1.5{C:inactive} mult -> {X:mult,C:white}X1.25{C:inactive} mult",
					"{C:green}1 in 15{C:inactive} for {C:money}$20{C:inactive} -> {C:money}$1.33",
					"{C:green}1 in 2{C:inactive} to generate {C:tarot}tarot{C:inactive} card -> generate {C:tarot}tarot{C:inactive} card every {C:green}2{C:inactive} tries",
					"{C:inactive,s:0.5}FRICK THE SIMPLEX ALGORITHM - Tea"
				}
			},
			j_foobar_8_ball = {
				name = "8 Ball",
				text = {
					"The first {C:green}#1# of every #2#{}",
					"scored {C:attention}8{} creates a",
					"{C:tarot}Tarot{} card",
					"{C:inactive}[Currently on trigger {C:attention}#3#{C:inactive}]",
					"{C:inactive}(Must have room)"
				}
			},
			j_foobar_gros_michel = {
				name = "Gros Michel",
				text = {
					"{C:mult}+#1#{} Mult",
					"this card is destroyed",
					"when {C:red}#2#{} reaches {C:red}0",
					"this number decreases by {C:green}#3#{}",
					"at end of round"
				}
			},
			j_foobar_or_business = {
				name = "Business Card",
				text = {
					"Played {C:attention}face{} cards",
					"give {C:money}$#1#{} when scored"
				}
			},
			j_foobar_or_space = {
				name = "Space Joker",
				text = {
					"upgrade level of",
					"played {C:attention}poker hand{}",
					"every first {C:attention}#1# out of #2#",
					"hands played",
					"{C:inactive}[Currently on hand {C:attention}#3#{C:inactive}]"
				}
			},
			j_foobar_or_cavendish = {
				name = "Cavendish",
				text = {
					"{X:mult,C:white}X#1#{} Mult",
					"this card is destroyed",
					"when {C:red}#2#{} reaches {C:red}0",
					"this number decreases by {C:green}#3#{}",
					"at end of round"
				}
			},
			j_foobar_or_reserved_parking = {
				name = "Reserved Parking",
				text = {
					"Each {C:attention}face{} card",
					"held in hand",
					"gives {C:money}$#1#{}"
				}
			},
			j_foobar_or_hallucination = {
				name = "Hallucination",
				text = {
					"The first {C:green}#1# of every #2#{}",
					"{C:attention}Booster Packs{} opened creates a",
					"{C:tarot}Tarot{} card",
					"{C:inactive}[Currently on trigger {C:attention}#3#{C:inactive}]",
					"{C:inactive}(Must have room)"
				}
			},
			j_foobar_or_bloodstone = {
				name = "Bloodstone",
				text = {
					"played cards with",
					"{C:hearts}Heart{} suit to give",
					"{X:mult,C:white} X#1# {} Mult when scored",
				}
			},
			j_foobar_fryer = {
				name = "Fryer",
				text = {
					"Before scoring",
					"{C:red}destroy{} right-most card",
					"held in hand and earn {C:money}$#1#"
				}
			},
			j_foobar_graphicscard = {
				name = "Graphics Card",
				text = {
					{
						"{C:mult}+#1#{} mult per",
						"{C:money}${} of this card's",
						"sell value",
						"{C:inactive}[Currently {C:mult}+#2#{C:inactive} Mult]"
					},
					{
						"This card's {C:money}price{} doubles",
						"Every time it appears in shop"
					}
				}
			},
			j_foobar_baguette = {
				name = "Baguette",
				text = {
					"Played {C:attention}face cards{}",
					"Earn {C:money}$#1#{} when scored",
					"Lasts for {C:red}#2#{} rounds"
				}
			},
			j_foobar_nic = {
				name = "nic",
				text = {
					"nic",
					"",
					"{s:0.7,C:inactive}Earn {s:0.7,C:money}$#1#{s:0.7,C:inactive} at end of round",
					"{s:0.5,C:inactive}And something else..."
				}
			}
		},
		Enhanced = {
			m_foobar_or_glass = {
				name = "Glass Card",
				text = {
					"{X:mult,C:white} X#1# {} Mult",
					"this card is destroyed",
					"when {C:red}#2#{} reaches {C:red}0",
					"this number decreases by {C:green}#3#{}",
					"at end of round"
				}
			},
			m_foobar_or_lucky = {
				name = "Lucky Card",
				text = {
					"{C:mult}+#1#{} Mult",
					"{C:money}$#2#"
				}
			}
		},
		Tarot = {
			c_foobar_or_wheel_of_fortune = {
				name = "Wheel of Fortune",
				text = {
					"The first {C:green}#1# of every #2#{} uses adds",
					"{C:dark_edition}Foil{}, {C:dark_edition}Holographic{}, or",
					"{C:dark_edition}Polychrome{} edition",
					"to a random {C:attention}Joker",
					"{C:inactive}[Currently on use {C:attention}#3#{C:inactive}]"
				}
			},
			c_foobar_dingus = {
				name = "The Dingus",
				text = {
					"Randomize {C:attention}suit{} and {C:attention}rank{}",
					"of up to {C:attention}#1#{} selected cards"
				}
			}
		},
		Mod = {
			foobar = {
				name = "Credits",
				text = {
					"Additional concept:",
					"{C:hearts,s:1}Kusanehexaku{C:inactive,s:1}",
					"{C:hearts,s:1}Tetocord{C:inactive,s:1}",
					"{C:clubs,s:1}Balatro Discord{C:inactive,s:1}",
					"{C:hearts,s:1}Glatcord{C:inactive,s:1}",
					"{C:diamonds,s:1}Tancord{C:inactive,s:1}",
					"{C:tarot,s:1}Monocord{C:inactive,s:1}",
					" ",
					"Programming help:",
					"{C:hearts,s:1}Balatro Discord{C:inactive,s:1}",
					" ",
					"Special thanks:",
					"SIMPLEX ALGORITHM",
					"{s:1}Rin0k038 - 'No.'",
					"{s:1}Zeurunix",
					"{s:1}Its Star! - 'space reasons'",
				}
			}
		},
		Back = {
			b_foobar_bargain = {
				name = "Bargain Deck",
				text = {
					"All items in shop cost {C:money}$#1#",
					"Blinds give {C:red}no{} rewards",
					"Earn {C:red}no{} interest"
				}
			}
		},
		Sleeve = {
			sleeve_foobar_bargain = {
				name = "Bargain Sleeve",
				text = {
					"All items in shop cost {C:money}$#1#",
					"Blinds give {C:red}no{} rewards",
					"Earn {C:red}no{} interest"
				}
			},
			sleeve_foobar_bargain_stacked = {
				name = "Bargain Sleeve",
				text = {
					"Start run with the",
					"{C:green,T:v_reroll_surplus}#1#{} and",
					"{C:green,T:v_reroll_glut}#2#{} vouchers",
				}
			}
		}
	}
}