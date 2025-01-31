
#macro CHECK_PAUSE if global.pause { exit }
#macro UPDATE_DEPTH if !depth_lock { depth = -(y - z - CamYCent()) }

#macro DEBUG_ON false
#macro Debug:DEBUG_ON true

draw_grid = false
camera_clamp_zoom = true
spawners_draw_enabled = false
pause = false
player_vision_enabled = true
watch_tower_show_radius = false
player_hit_effect_color = c_red
player_hit_effect_alpha = 0.9

gameover =false
victory = false

playground_mode = true

locked_abilities_low_tier = []

locked_abilities_high_tier = []

unseen_low_scrolls = []
unseen_high_scrolls = []

enemy_hit_sfx = [sfxPunch5, sfxHit, sfxHit1]
player_hit_sfx = [sfxPunch1]

if DEBUG_ON {
	draw_grid = true
	camera_clamp_zoom = false
	player_vision_enabled = false
    watch_tower_show_radius = true
}

function ResetGlobals() {
    global.locked_abilities_low_tier = [
        oUIButtonHealAura,
        oUIButtonProtectionAura,
        oUIButtonShipRepair,
        oUIButtonSpeedBoost,
    ]
    
    global.locked_abilities_high_tier = [
        oUIButtonAmberWrath
    ]

    global.unseen_low_scrolls = []
    global.unseen_high_scrolls = []
    global.gameover = false
    global.victory = false
    
}

ResetGlobals()
