
CHECK_PAUSE

if !check_timer.update() {
	enemy_nearby = noone
    check_timer.reset()
    EntitiesListCircle(x, y, spawn_distance, instances_list)
    for (var i = 0; i < ds_list_size(instances_list); ++i) {
        var inst = instances_list[| i]
        if inst.is_creature and IsEnemySide(inst) {
            enemy_nearby = inst
            break
        }
    }
    ds_list_clear(instances_list)
}

if enemy_nearby and !spawn_timer.update() {
    is_spawning = true
}

if is_spawning and !between_spawns_timer.update() {
    if !instance_exists(enemy_nearby) {
        enemy_nearby = noone
    } else {
        if spawn_number-- {
            var inst = instance_create_layer(
                x - 300 + random(600),
                y - 300 + random(600),
                "Instances", oEnemyCrawlp)
            inst.move_target.setv(enemy_nearby.position)
            between_spawns_timer.reset()
        } else {
            spawn_timer.reset()
            is_spawning = false
            instance_destroy() // one time
        }
    }
}
