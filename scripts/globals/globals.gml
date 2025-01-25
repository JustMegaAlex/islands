draw_grid = false
camera_clamp_zoom = true
spawners_draw_enabled = false

locked_abilities_low_tier = []

locked_abilities_high_tier = []

unseen_low_scrolls = []
unseen_high_scrolls = []

function ResetGlobals() {
    locked_abilities_low_tier = [
        oUIButtonHealAura,
        oUIButtonProtectionAura,
    ]
    
    locked_abilities_high_tier = [
        oUIButtonAmberWrath
    ]

    unseen_low_scrolls = []
    unseen_high_scrolls = []
}

ResetGlobals()
