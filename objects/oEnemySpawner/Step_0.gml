
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
    repeat spawn_randomer() {
        var inst = instance_create_layer(x, y, "Instances", oEnemyCrawlp)
        inst.move_target.setv(enemy_nearby.position)
    }
    spawn_timer.reset()
}
