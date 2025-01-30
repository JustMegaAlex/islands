
is_ship_navigating = false

mx = 0
my = 0
active_ui = noone
mouse_over_ui = noone

collision_list = ds_list_create()

ui_object = oUIActionButtonParent

rclick_pressed_timer = MakeTimer(10000)
lclick_pressed_timer = MakeTimer(10)
crew_select_box = {
    x0: 0, y0: 0, x1: 0, y1: 0, enabled: false
}
resource_select_box = {
    x0: 0, y0: 0, x1: 0, y1: 0, enabled: false
}

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

function RectCollisionInstances(x0, y0, x1, y1, fun) {
    var count = collision_rectangle_list(
        x0, y0, x1, y1, oEntity, false, false, collision_list, false)
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

alarm[0] = 1

