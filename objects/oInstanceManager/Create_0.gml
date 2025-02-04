
grid_active_distance = 1
vec_check = new Vec2(0, 0)
active_areas = []

current_instance_index = 0
max_instances_per_step = 100

function AreaActivate(area) {
    area.is_activated = true
    array_push(active_areas, area)
    for (var i = 0; i < array_length(area.instances); ++i) {
        var inst = area.instances[i]
        InstanceActivate(inst, id)
    }
}
function AreaDeactivate(area) {
    area.is_activated = false
    ArrayRemove(active_areas, area)
    for (var i = 0; i < array_length(area.instances); ++i) {
        var inst = area.instances[i]
        InstanceDeactivate(inst, id)
    }
}
function MoveToArea(inst, area) {
    if inst.world_grid_area != undefined {
        ArrayRemove(inst.world_grid_area.instances, inst)
    }
    array_push(area.instances, inst)
    inst.world_grid_area = area
}

function GridDistV(vec1, vec2) {
    return max(abs(vec1.x - vec2.x), abs(vec1.y - vec2.y))
}
function GridDist(x1, y1, x2, y2) {
    return max(abs(x1 - x2), abs(y1 - y2))
}
