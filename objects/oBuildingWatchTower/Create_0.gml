
event_inherited()

hit_effect_color = global.player_hit_effect_color
hit_effect_alpha = global.player_hit_effect_alpha

default_color = c_silver
default_rect.set(80, 120)


side = EntitySide.ours
SetFriendlyWith(EntitySide.nature)
SetFriendlyWith(EntitySide.ours)
SetFriendlyWith(EntitySide.neutral)

is_structure = true

hp_max = global.hp_guard_tower
hp = global.hp_guard_tower

build_timer.time = 60
build_timer.timer = 60

scan_range = global.watch_tower_scan_range
islands_list = ds_list_create()

function BuildingFinished() {
    collision_circle_list(x, y, scan_range, oIsland, false, false, islands_list, false)
    for (var i = 0; i < ds_list_size(islands_list); ++i) {
        var isl = islands_list[| i]
        isl.ScanReveal()
    }
}
