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
					"cards change {C:enhanced}enhancements",
					"Card must already have an {C:enhanced}enhancement",
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
						"Future occurances of this card's {C:money}price{} doubles",
						"at the end of round"
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
			},
			j_foobar_lefisheauchocolat = {
				name = "Le Fishe au chocolat",
				text = {
					{
						"Cards have a {C:green}#1# in #2#{} chance",
						"To be drawn {C:attention}face down{}",
						"{C:attention}Face down{} cards are treated as {C:enhanced}wild{} cards",
						"and give {C:mult}+#3#{} mult when scored"
					},
					{
						"{C:red}Due to SMODS issues, this will induce",
						"{C:red}significant lag"
					}
				}
			},
			j_foobar_lefisheauchocolat_simplex = {
				name = "Le Fishe au chocolat",
				text = {
					{
						"{C:green}#1# of every #2#{} cards",
						"are drawn {C:attention}face down{}",
						"{C:attention}Face down{} cards are treated as {C:enhanced}wild{} cards",
						"and give {C:mult}+#3#{} mult when scored"
					},
					{
						"{C:red}Due to SMODS issues, this will induce",
						"{C:red}significant lag"
					}
				}
			},
			j_foobar_adachirei = {
				name = "Adachi Rei",
				text = {
					"{s:0.7}+#1# * sin(time) + #1# chips",
					"{C:inactive,s:0.7}WHAT DO YOU MEAN YOU RECREATED THE HUMAN VOICE WITH SINE WAVES"
				}
			},
			j_foobar_whiplash = {
				name = "Whiplash",
				text = {
					"Once per blind",
					"{C:attention}click{} on a card in your {C:attention}deck{}",
					"to draw it to hand",
					"{C:attention}#2#{} hand size",
					"{C:inactive}#1#!{}"
				}
			},
			j_foobar_mitosis = {
				name = "Mitosis",
				text = {
					"Fixed {C:green}#1# in #2#{} chance",
					"to duplicate used {C:attention}consumable"
				}
			},
			j_foobar_mitosis_simplex = {
				name = "Mitosis",
				text = {
					"Duplicate every other",
					"used {C:attention}consumable"
				}
			},
			j_foobar_splitdance = {
				name = "Split Dance",
				text = {
					"Sliced cards calculate",
					"effects a {C:attention}third{} time"
				}
			},
			j_foobar_cigarette = {
				name = "Cigarette",
				text = {
					"If played hand one shots the blind",
					"{C:red}Destroy{} {C:attention}#2#{} card in deck",
					"{C:red}-#1#{} hand size"
				}
			},
			j_foobar_teto = {
				name = "Kasane Teto",
				text = {
					"Played {C:attention}4's{} and {C:attention}aces",
					"Give {X:chips,C:white}X#1#{} chips",
					"when scored"
				}
			},
			j_foobar_pearto = {
				name = "Pearto",
				text = {
					{
						"{C:green}#1# in #2#{} chance",
						"to create {C:legendary}Kasane Teto",
						"at {C:attention}end of round{}"
					},
					{
						"{C:green}#3# in #4#{} chance",
						"to {C:red}destroy{} self at {C:attention}end of round"
					}
				}
			},
			j_foobar_companioncube = {
				name = "Companion Cube",
				text = {
					"If it could talk -",
					"and the Enrichment Center takes",
					"this opportunity to remind you",
					"that it cannot -",
					"it would tell you to go on without",
					"it becuase it would rather die",
					"in a fire than become",
					"a burden to you"
				}
			},
			j_foobar_feedback = {
				name = "FEEDBACK",
				text = {
					"This joker gains {C:mult}+#2#{} mult",
					"if {C:attention}scored hand{} contains",
					"a {C:attention}wild ace of spades{}",
					"{C:inactive}[Currently {C:mult}+#1#{C:inactive} Mult]"
				}
			},
			j_foobar_hitomania = {
				name = "HITO Mania",
				text = {
					"Played {C:attention}face{} cards",
					"give {C:mult}#1#{} to {C:mult}#2#{} mult,",
					"or {C:chips}#3#{} to {C:chips}#4#{} chips",
					"when scored"
				}
			},
			j_foobar_plagiarism = {
				name = "Plagiarism",
				text = {
					{
						"Copies {C:attention}#1#{} random",
						"non-{C:dark_edition}negative{} jokers",
						"you own every round",
						"{C:inactive,s:0.8}can copy the same card twice"
					},
					{
						"Currently copying",
						"{C:attention}#2#{} and {C:attention}#3#"
					}
				}
			},
			j_foobar_twitter = {
				name = "Twitter",
				text = {
					{
						"Gains {C:chips}#1#{} chips",
						"per {C:red}debuffed{} card played",
						"{C:inactive}[Currently {C:chips}#2#{C:inactive} Chips]"
					},
					{
						"After hand is drawn",
						"debuff a random card"
					}
				}
			},
			j_foobar_x = {
				name = "X",
				text = {
					{
						"Gains {C:chips}#1#{} chips",
						"per {C:red}debuffed{} card played",
						"{C:inactive}[Currently {C:chips}#2#{C:inactive} Chips]"
					},
					{
						"After hand is drawn",
						"debuff a random card"
					}
				}
			},

			-- create machines
			j_foobar_create_belt = {
				name = "Mechanical Belt",
				text = {
					"Unscored cards are",
					"affected by {C:foobar_create}Create{} cards"
				}
			},
			j_foobar_create_arm = {
				name = "Mechanical Arm",
				text = {
					"Move the first card to",
					"the back of the line",
					"after its processed"
				}
			},
			j_foobar_create_press = {
				name = "Mechanical Press",
				text = {
					"Cards gain their rank in {C:mult}mult",
					"before losing half of it"
				}
			},
			j_foobar_create_press_basin = {
				name = {"Mechanical Press", "{s:0.8}(In a Basin)"},
				text = {
					"Cards of the same rank",
					"are compressed into one card",
					"after scoring"
				}
			},
			j_foobar_create_handcrank = {
				name = "Hand Crank",
				text = {
					"Force trigger adjacent",
					"{C:foobar_create}Create{} cards"
				}
			},
			j_foobar_create_blazeburner = {
				name = "Blaze Burner",
				text = {
					"{C:attention}Double{} values of",
					"{C:foobar_create}Create{} card",
					"to the left"
				}
			},
			j_foobar_create_blazeburner_superheated = {
				name = {"Blaze Burner", "{s:0.8}(Superheated)"},
				text = {
					"{C:attention}Triple{} values of",
					"{C:foobar_create}Create{} card",
					"to the left"
				}
			},
			j_foobar_create_mixer = {
				name = "Mechanical Mixer",
				text = {
					"{C:red}Remove{} a random modification",
					"to give it {X:mult,C:white}X#1#{} Xmult"
				}
			},
			j_foobar_create_mixer_basin = {
				name = {"Mechanical Press", "{s:0.8}(In a Basin)"},
				text = {
					"{C:attention}Mix{} the {C:attention}first{} card",
					"of each {C:attention}rank{}",
					"into a {C:attention}new{} card"
				}
			},
			j_foobar_create_fan = {
				name = "Encased Fan",
				text = {
					"Increase {C:attention}card's",
					"rank by {C:attention}#1#"
				}
			},
			j_foobar_create_deployer = {
				name = "Deployer",
				text = {
					"{C:green}#1# in #2#{} chance to",
					"copy the last used",
					"{C:Tarot}Tarot{} card"
				}
			},
			j_foobar_create_saw = { -- requires aikoshen
				name = "Mechanical Saw",
				text = {
					"Splits card into",
					"Their rank and suit"
				}
			},
			j_foobar_create_harvester = {
				name = "Mechanical Harvester",
				text = {
					"Face cards are cut",
					"down into #1#'s",
					"Earn {C:money}$#2#{} per card",
					"harvested"
				}
			},
			j_foobar_create_plough = {
				name = "Mechanical Plough",
				text = {
					"Destroy played #1#'s"
				}
			},
			j_foobar_create_drill = {
				name = "Mechanical Drill",
				text = {
					"Decrease cards rank by #1#"
				}
			},
			j_foobar_create_frogport = {
				name = "Frogport",
				text = {
					"Draw and score",
					"top card of deck",
					"If under #1# cards",
					"are played"
				}
			},
			j_foobar_create_vault = {
				name = "Item Vault",
				text = {
					"Store {X:mult,C:white}Xmult{} from cards",
					"until after cards are scored",
				}
			},
			j_foobar_create_millstone = {
				name = "Millstone",
				text = {
					"Cards gain their rank in chips",
					"and then decrease their rank",
					"by #1#"
				}
			},
			j_foobar_create_crushingwheels = {
				name = "Crushing Wheels",
				text = {
					"Played cards are destroyed",
					"after scoring",
					"{C:green}#1# in #2#{} chance",
					"to create a copy",
					"of destroyed cards",
					"with x#3# values"
				}
			},
			j_foobar_create_crafter = {
				name = "Mechanical Crafter",
				text = {
					{
						"Play the cards",
						"listed below to",
						"destroy them and",
						"create a spectral card"
					},
					{
						"#1#",
						"#2#",
						"#3#",
						"#4#",
						"#5#"
					}
				}
			},

			--- Fan - cards gain x0.1 chips
			--- Mixer - cards also gain +20 chips
			--- Mixer + Basin - x1.5 stats after mixing
			--- Press + Basin - create an copy of the new card
			--- Blazeburner - half stats instead
			j_foobar_create_waterbucket = {
				name = "Water Bucket",
				text = {
					"Adds an effect to the",
					"{C:foobar_create}Create{} card",
					"to the left"
				}
			},
			--- Fan - 1 in 2 chance to gain x0.2 mult, otherwise destroy card
			--- Mixer - cards also gain +2 mult
			--- Mixer + Basin - upgrade cards edition
			--- Press + Basin - x1.5 stats after compressing
			--- Blazeburner - superheat
			j_foobar_create_lavabucket = {
				name = "Lava Bucket",
				text = {
					"Adds an effect to the",
					"{C:foobar_create}Create{} card",
					"to the left"
				}
			},
			--- Fan - cards gain +5 mult
			--- Mixer - cards gain +2 mult when held in hand
			--- Mixer + Basin - cards gain +4 mult when held in hand
			--- Press + Basin - x1.1 stats after compressing
			--- Blazeburner - x2.2 values
			j_foobar_create_fire = {
				name = "Fire",
				text = {
					"Adds an effect to the",
					"{C:foobar_create}Create{} card",
					"to the left"
				}
			},
			--- Fan - cards gain a random modification
			--- Mixer - give a random enhancement back
			--- Mixer + Basin - Rank will be the highest rank not mixed, and gain mult based on this rank
			--- Press + Basin - Randomize rank and suit, and gain mult based on this rank
			--- Blazeburner - swap changes to chips and mult
			j_foobar_create_soulfire = {
				name = "Soulfire",
				text = {
					"Adds an effect to the",
					"{C:foobar_create}Create{} card",
					"to the left"
				}
			},

			j_foobar_create_basin = {
				name = "Basin",
				text = {
					"Changes the effect of the",
					"{C:foobar_create}Create{} card",
					"to the left"
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
			},
			c_foobar_robot = {
				name = "The Robot",
				text = {
					"Create {C:attention}#2#{} copies of {C:attention}#1#{} selected card",
					"The {C:attention}first{} copy will have randomized {C:attention}suit",
					"The {C:attention}second{} copy will have randomized {C:attention}rank"
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
					"{C:hearts,s:1}Balatro Discord",
					"{C:edition,s:1}LasagnaFelidae",
					"{s:1}TheOneGoofAli",
					" ",
					"Special thanks:",
					"SIMPLEX ALGORITHM",
					"{s:1}aikoyori",
					" ",
					"People who asked",
					"{s:1}Rin0k038 - 'No.'",
					"{s:1}Zeurunix",
					"{s:1}Its Star! - 'space reasons'",
					"{s:1}☆ lexi ☆",
					"{s:1}John Balatro",

					"Minesweeper quips:",
					"{s:1}FirstTry, notmario, gabby, mys.minty, aure",
					"{s:1}Kusane, Jade Penguin, kel"
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
			},
			b_foobar_adaptive = {
				name = "Adaptive Deck",
				text = {
					"When defeating an enabled boss blind",
					"for the first time this run,",
					"gain a permanent ability"
				}
			},
			b_foobar_custom = {
				name = "Custom Deck",
				text = {
					"Spend points to",
					"customize your deck",
					"before starting a run"
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
			},
			sleeve_foobar_adaptive = {
				name = "Adaptive Sleeve",
				text = {
					"When defeating an enabled boss blind",
					"for the first time this run,",
					"gain a permanent ability"
				}
			},
			sleeve_foobar_adaptive_stacked = {
				name = "Adaptive Sleeve",
				text = {
					"Start run with the",
					"{C:green,T:v_retcon}#1#{} and",
					"{C:green,T:v_directors_cut}#2#{} vouchers",
				}
			}
		},
		Spectral = {
			c_foobar_sudormrf = {
				name = "sudo rm -rf / --no-preserve-root",
				text = {
					"Destroys {C:red}all{} cards in {C:attention}deck,",
					"a random joker,",
					"and a random card held in hand"
				}
			},
			c_foobar_vb_crypton = {
				name = "Crypton Media",
				text = {
					"{V:1}Voicebanks{} do not destroy",
					"other active {V:1}Voicebanks{} on use",
					"but {C:red}can't{} become {C:dark_edition}negative"
				}
			}
		},
		Tag = {
			fbminigame_foobar_projectsekai = {
				name = "Project Sekai",
				text = {
					"Beat a pjsk chart",
					"{C:inactive,s:0.7}Around a Hard 20",
					"to win {C:attention}4{} copies",
					"of the above skip tag"
				}
			},
			fbminigame_foobar_tetobaguettecatch = {
				name = "Baguette Catch",
				text = {
					"Catch the falling baguettes",
					"to win a minigame tag!"
				}
			},
			fbminigame_foobar_minesweeper = {
				name = "Minesweeper",
				text = {
					"Beat minesweeper",
					"to make the",
					"{C:attention}Emotional Support Card",
					"{C:dark_edition}negative"
				}
			}
		},
		Voicebank = {
			c_foobar_vb_meiko = {
				name = "MEIKO",
				text = {
					"All {C:hearts}#1#{} are {C:attention}retriggered",
					"{C:green}#2# in #3#{} chance for non-{C:hearts}#1#{}",
					"to be {C:red}debuffed"
				}
			},
			c_foobar_vb_meiko_simplex = {
				name = "MEIKO",
				text = {
					"All {C:hearts}#1#{} are {C:attention}retriggered",
					"{C:green}#2# out of every #3#{} non-{C:hearts}#1#{}",
					"are {C:red}debuffed"
				}
			},
			c_foobar_vb_kaito = {
				name = "KAITO",
				text = {
					"Scored {C:clubs}#1#{} permanently gain",
					"{C:blue}+#2#{} chips and {C:red}+#3#{} mult"
				}
			},
			c_foobar_vb_rinlen = {
				name = {
					"Kagamine Rin",
					"Kagamine Len"
				},
				text = {
					"Cards {C:attention}held in hand",
					"at {C:attention}end of round",
					"gain {C:money}$#1#{} when",
					"either {C:attention}held in hand",
					"at {C:attention}end of round",
					"or scored"
				}
			},
			c_foobar_vb_miku = {
				name = "Hatsune Miku",
				text = {
					"Scored {C:attention}#1#{}'s and {C:attention}#2#{}'s",
					"permanently gain {X:blue,C:white}X#3#{} chips"
				}
			},
			c_foobar_vb_luka = {
				name = "Megurine Luka",
				text = {
					"After hand is drawn",
					"draw up to {C:attention}#1#{} cards",
					"of the same rank",
					"of a random card in hand"
				}
			},
			c_foobar_vb_neru = {
				name = "Akita Neru",
				text = {
					{
						"{C:attention}Copies{} most effects",
						"of a random {V:1}Voicebank",
						"every {C:attention}round"
					},
					{
						"Currently copying {C:attention}#1#"
					}
				}
			},
			c_foobar_vb_sv_teto = {
				name = {
					"Kasane Teto",
					"{s:0.7}SynthV"
				},
				text = {
					"If played hand is",
					"a {C:attention}#1#{} of {C:hearts}#2#",
					"create a copy of scored cards",
					"at the bottom of the deck"
				}
			},
			c_foobar_vb_utau_teto = {
				name = {
					"Kasane Teto",
					"{s:0.7}UTAU"
				},
				text = {
					"Scored {C:hearts}#1#{} permanently gain",
					"{X:mult,C:white}X#2#{} mult when {C:attention}held in hand"
				}
			},
			c_foobar_vb_momone = {
				name = "Momo Momone",
				text = {
					"If first hand of round",
					"contains more than {C:attention}#1#{} card",
					"make the last card {C:dark_edition}Polychrome"
				}
			},
			c_foobar_vb_defoko = {
				name = "Utane Uta",
				text = {
					"Creates the {C:attention}default",
					"card from a random",
					"{C:attention}consumable type",
					"when blind is {C:attention}selected"
				}
			},
			c_foobar_vb_rei = {
				name = "Adachi Rei",
				text = {
					"Scored {C:diamonds}#1#{} permanently gain",
					"{C:chips}+#2#{} chips"
				}
			},
			c_foobar_vb_yuki = {
				name = "Kaai Yuki",
				text = {
					"Scored {C:spades}#1#{} decrease",
					"their rank by {C:attention}#2#",
					"and permanently gain {C:attenion}their rank{} in {C:mult}mult"
				}
			},
			c_foobar_vb_kafu = {
				name = "KAFU",
				text = {
					"{C:red}Destroy{} all cards in",
					"{C:attention}first hand of round"
				}
			},
			c_foobar_vb_flower = {
				name = "Flower",
				text = {
					"Cards held in hand",
					"permanently gain {X:mult,C:white}X#1#{} mult",
					"if scored hand contains a",
					"{C:diamonds}Diamond{} card, {C:clubs}Club{} card,",
					"{C:hearts}Heart{} card, and {C:spades}Spade{} card"
				}
			},
			c_foobar_vb_zundamon = {
				name = "Zundamon",
				text = {
					"If played hand is a {C:attention}#1#",
					"retrigger all cards"
				}
			},
			c_foobar_vb_gumi = {
				name = "GUMI",
				text = {
					"played {C:attention}Kings{} and {C:attention}Queens{} have a",
					"{C:green}#1# in #2#{} chance to",
					"permanently gain a retrigger"
				}
			},
			c_foobar_vb_gumi_simplex = {
				name = "GUMI",
				text = {
					"{C:green}#1# of every #2#{} scored",
					"{C:attention}King{} or {C:attention}Queen",
					"permanently gains a retrigger"
				}
			},
			c_foobar_vb_una = {
				name = "Otomachi Una",
				text = {
					"{C:attention}Randomized{} scored cards {C:attention}rank{} after scoring",
					"Scored cards permanently gain",
					"the difference between ranks in {C:mult}mult",
					"when {C:attention}held in hand"
				}
			},
			c_foobar_vb_yixi = {
				name = "Yi Xi",
				text = {
					"Scored {C:attention}face{} cards permanently gain",
					"{X:mult,C:white}X#1#{} mult",
					"but have a {C:green}#2# in #3#{} chance to be {C:red}destroyed"
				}
			},
			c_foobar_vb_yixi_simplex = {
				name = "Yi Xi",
				text = {
					"Scored {C:attention}face{} cards permanently gain",
					"{X:mult,C:white}X#1#{} mult",
					"but {C:green}#2# of every #3#{} are {C:red}destroyed"
				}
			},
			c_foobar_vb_ia = {
				name = "IA",
				text = {
					"Scored {C:attention}Aces{} permanently gain",
					"{C:chips}+#1#{} chips and {C:mult}+#2#{} mult"
				}
			},
			c_foobar_vb_forte = {
				name = "Eleanor Forte",
				text = {
					"Unscored cards permanently gain",
					"{C:attention}their rank{} in {C:chips}chips"
				}
			},
		},
		Edition = {
			e_foobar_working = {
				name = "Active!",
				text = {
					"This card is {C:green}active!"
				}
			}
		},
		Other = {
			foobar_vb_info = {
				name = "Voicebank Info",
				text = {
					"Using an inactive {V:1}Voicebank",
					"makes it {C:dark_edition}negative{} and {C:purple}eternal",
					"and {C:red}destroys{} active {V:1}Voicebanks",
					"Using an active {V:1}Voicebank {C:red}destroys it"
				}
			},
			foobar_vb_info_crypton = {
				name = "Voicebank Info",
				text = {
					"Using an inactive {V:1}Voicebank",
					"makes it {C:purple}eternal",
					"Using an active {V:1}Voicebank {C:red}destroys it"
				}
			},
			p_foobar_voicebank_normal = {
				name = "Voicebank Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{V:1} Voicebank{} cards to take",
				}
			},
			p_foobar_voicebank_jumbo = {
				name = "Jumbo Voicebank Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{V:1} Voicebank{} cards to take",
				}
			},
			p_foobar_voicebank_mega = {
				name = "Mega Voicebank Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{V:1} Voicebank{} cards to take",
				}
			},
			ba_bl_hook = {
				text = {
					"Retrigger {C:attention}2{} random cards",
					"held in hand"
				}
			},
			ba_bl_ox = {
				text = {
					"Playing your {C:attention}most played hand{}",
					"Earns {C:money}$5"
				}
			},
			ba_bl_house = {
				text = {
					"Retrigger {C:attention}all cards",
					"in first played hand"
				}
			},
			ba_bl_wall = {
				text = {
					"{X:mult,C:white}X2{} mult"
				}
			},
			ba_bl_wheel = {
				text = {
					"{C:green}1 in 7{} chance to",
					"retrigger cards",
					"{C:inactive,s:0.7}This is affected by cards such as oops and simplex"
				}
			},
			ba_bl_arm = {
				text = {
					"{C:green}Increase{} level of",
					"played {C:attention}poker hand"
				}
			},
			ba_bl_club = {
				text = {
					"All {C:attention}suits{} are",
					"treated as {C:clubs}clubs"
				}
			},
			ba_bl_fish = {
				text = {
					"Retrigger {C:attention}all{} cards",
					"{C:attention}not{} in starting hand"
				}
			},
			ba_bl_psychic = {
				text = {
					"Return all {C:attention}played cards",
					"to hand if {C:attention}5{} cards",
					"were played"
				}
			},
			ba_bl_goad = {
				text = {
					"All {C:attention}suits{} are",
					"treated as {C:spades}spades"
				}
			},
			ba_bl_water = {
				text = {
					"Gain the number of discards",
					"you lost while playing",
					"this blind permanently"
				}
			},
			ba_bl_window = {
				text = {
					"All {C:attention}suits{} are",
					"treated as {C:diamonds}diamonds"
				}
			},
			ba_bl_manacle = {
				text = {
					"+1 hand size"
				}
			},
			ba_bl_eye = {
				text = {
					"Retrigger {C:attention}all{} played cards",
					"while only {C:attention}one{} hand type",
					"has been scored",
					"this {C:attention}round"
				}
			},
			ba_bl_mouth = {
				text = {
					"Retrigger {C:attention}all{} played cards",
					"while no {C:attention}hand{} types",
					"have been scored twice",
					"this {C:attention}round"
				}
			},
			ba_bl_plant = {
				text = {
					"All {C:attention}face{} cards",
					"give {X:mult,C:white}X1.25{} mult"
				}
			},
			ba_bl_serpent = {
				text = {
					"Always draw",
					"at least {C:attention}3{} cards"
				}
			},
			ba_bl_pillar = {
				text = {
					"Prioritize drawing cards",
					"that have already been",
					"{C:attention}played{} this ante"
				}
			},
			ba_bl_needle = {
				text = {
					"Gain the number of hands",
					"you lost while playing",
					"this blind {C:attention}permanently"
				}
			},
			ba_bl_head = {
				text = {
					"All {C:attention}suits{} are",
					"treated as {C:heart}heart"
				}
			},
			ba_bl_tooth = {
				text = {
					"Earn {C:money}$1{} per",
					"card played"
				}
			},
			ba_bl_flint = {
				text = {
					"Base {C:chips}chips{} and",
					"{C:mult}mult{} are doubled"
				}
			},
			ba_bl_mark = {
				text = {
					"Retrigger all",
					"{C:attention}face{} cards"
				}
			},
			ba_bl_final_acorn = {
				text = {
					"I have no clue what this should do",
					"lmk if you got any ideas",
					"discord @foo54"
				}
			},
			ba_bl_final_leaf = {
				text = {
					"{C:dark_edition}+1{} joker slot"
				}
			},
			ba_bl_final_vessel = {
				text = {
					"{X:mult,C:white}X3{} mult"
				}
			},
			ba_bl_final_heart = {
				text = {
					"Before scoring, select a {C:attention}random{} joker",
					"this joker will also be {C:attention}treated{} as a {C:blue}blueprint{}"
				}
			},
			ba_bl_final_bell = {
				text = {
					"After drawing cards,",
					"modify {C:attention}one{} random card",
					"{C:attention}held{} in hand"
				}
			}
		}
	},
	misc = {
		dictionary = {
			k_voicebank = "Voicebank",
			b_voicebank_cards = "Voicebanks",
			k_voicebank_pack = "Voicebank Pack"
		},
		labels = {
			voicebank = "Voicebank",
			foobar_working = "Active!"
		}
	}
}