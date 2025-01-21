
if !check_timer.update() {
	is_enemy_near = false
    check_timer.reset()
    for (var i = 0; i < array_length(island.entities); ++i) {
        var inst = island.entities[i]
        if inst.is_creature and IsEnemySide(inst) {
            is_enemy_near = true
            break
        }
    }
}


if is_enemy_near and !spawn_timer.update() {
    var pos = spawn_position.add_polar_(spawn_distance, random(360))
    while collision_point(pos.x, pos.y, oIsland, false, false) {
        pos = spawn_position.add_polar_(spawn_distance, random(360))
    }
    repeat spawn_randomer() {
        var inst = instance_create_layer(pos.x, pos.y, "Instances", oEnemyCrawlp)
        inst.move_target.set(x, y)
    }
    spawn_timer.reset()
}
