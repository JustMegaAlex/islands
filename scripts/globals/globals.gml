
#macro CHECK_PAUSE if global.pause { exit }

#macro DEBUG_ON false
#macro Debug:DEBUG_ON true

draw_grid = false
camera_clamp_zoom = true
spawners_draw_enabled = false
pause = false
player_vision_enabled = true
watch_tower_show_radius = false

locked_abilities_low_tier = []

locked_abilities_high_tier = []

unseen_low_scrolls = []
unseen_high_scrolls = []

if DEBUG_ON {
	draw_grid = true
	camera_clamp_zoom = false
	player_vision_enabled = false
    watch_tower_show_radius = true
}

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
