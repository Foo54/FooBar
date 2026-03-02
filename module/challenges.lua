if true then return end


--- idk
SMODS.Challenge {
    key = 'idk',
    jokers = {
        { id = 'j_perkeo', eternal = true, edition = 'negative' },
    },
    restrictions = {
        banned_cards = {
            { id = 'j_vagabond' },
            { id = 'j_superposition' },
            { id = 'j_certificate' },
            { id = 'c_incantation' },
            { id = 'c_magician' },
						--{ id = 'c_'}
            { id = 'c_empress' },
            { id = 'c_heirophant' },
            { id = 'c_chariot' },
            { id = 'c_devil' },
            { id = 'c_tower' },
            { id = 'c_lovers' },
            { id = 'c_incantation' },
            { id = 'c_grim' },
            { id = 'c_familiar' },
            { id = 'v_magic_trick' },
            { id = 'v_illusion' },
            { id = 'p_standard_normal_1', ids = {
                'p_standard_normal_1', 'p_standard_normal_2',
                'p_standard_normal_3', 'p_standard_normal_4',
                'p_standard_jumbo_1', 'p_standard_jumbo_2',
                'p_standard_mega_1', 'p_standard_mega_2' }
            },
        },
        banned_tags = {
            { id = 'tag_standard' },
        }
    },
    deck = {
        type = 'Challenge Deck',
        enhancement = 'm_glass'
    }
}