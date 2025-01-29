
grid_active_distance = 2
vec_check = new Vec2(0, 0)
active_areas = []

function AreaActivate(area) {
    area.is_activated = true
    array_push(active_areas, area)
    for (var i = 0; i < array_length(area.instances); ++i) {
        var inst = area.instances[i]
        instance_activate_object(inst)
    }
}
function AreaDeactivate(area) {
    area.is_activated = false
    ArrayRemove(active_areas, area)
    for (var i = 0; i < array_length(area.instances); ++i) {
        var inst = area.instances[i]
        instance_deactivate_object(inst)
    }
}
function MoveToArea(inst, area) {
    if inst.world_grid_area != undefined {
        ArrayRemove(inst.world_grid_area.instances, inst)
    }
    array_push(area.instances, inst)
    inst.world_grid_area = area
}

function GridDist(vec1, vec2) {
    return max(abs(vec1.x - vec2.x), abs(vec1.y - vec2.y))
}
