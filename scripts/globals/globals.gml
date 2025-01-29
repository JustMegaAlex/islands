draw_grid = true
camera_clamp_zoom = false
spawners_draw_enabled = false
player_vision_enabled = false

watch_tower_show_radius = true

locked_abilities_low_tier = []

locked_abilities_high_tier = []

unseen_low_scrolls = []
unseen_high_scrolls = []

function ResetGlobals() {
    locked_abilities_low_tier = [
        oUIButtonHealAura,
        oUIButtonProtectionAura,
        oUIButtonShipRepair,
        oUIButtonSpeedBoost,
    ]
    
    locked_abilities_high_tier = [
        oUIButtonAmberWrath
    ]

    unseen_low_scrolls = []
    unseen_high_scrolls = []
}

ResetGlobals()
