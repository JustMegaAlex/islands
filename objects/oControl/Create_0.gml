
is_ship_navigating = false

mx = 0
my = 0
active_ui = noone

collision_list = ds_list_create()

function MouseCollisionInstances(fun) {
    var count = collision_point_list(
        mouse_x, mouse_y, oEntity, false, false, collision_list, false)
    var found_instances = false
    for (var i = 0; i < count; ++i) {
        var inst = collision_list[| i]
        if fun(inst) {
			found_instances = true
			break
        }
    }
    ds_list_clear(collision_list)
    return found_instances
}
