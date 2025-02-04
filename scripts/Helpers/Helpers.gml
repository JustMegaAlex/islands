
function IsCrew(inst) {
    return inst.is_creature and inst.object_index != oShip and inst.side == EntitySide.ours
}

function FlyingInstDist(inst) {
    return point_distance(x, y + z, inst.x, inst.y + inst.z)
}
function FlyingInstDir(inst) {
    return point_direction(x, y + z, inst.x, inst.y + inst.z)
}

function EntitiesListCircle(x, y, r, list) {
    return collision_circle_list(x, y, r, oEntity, false, false, list, false)
}

function EntitiesListRect(x0, y0, x1, y1, list) {
    return collision_rectangle_list(x0, y0, x1, y1, oEntity, false, false, list, false)
}

function EntitiesInCircle(x, y, r, filter=undefined) {
    var list = ds_list_create()
    var count = EntitiesListCircle(x, y, r, list)   
    var res = []
    array_resize(res, count)
    if filter == undefined {
        for (var i = 0; i < count; i++) {
            res[i] = list[| i]
        }
        return res
    }
    var j = 0
    for (var i = 0; i < count; i++) {
        if filter(list[| i]) {
            res[j] = list[| i]
            j++
        }
    }
    ds_list_destroy(list)
    array_resize(res, j)
    return res
}

function EntitiesInRect(x0, y0, x1, y1, filter=undefined) {
    var list = ds_list_create()
    var count = EntitiesListRect(x0, y0, x1, y1, list)   
    var res = []
    array_resize(res, count)
    if filter == undefined {
        for (var i = 0; i < count; i++) {
            res[i] = list[| i]
        }
        return res
    }
    var j = 0
    for (var i = 0; i < count; i++) {
        if filter(list[| i]) {
            res[j] = list[| i]
            j++
        }
    }
    ds_list_destroy(list)
    array_resize(res, j)
    return res
}

function SetFriendlyWith(side) {
    friendly_with |= power(2, side)
}

function IsEnemySide(inst) {
    var _side = inst.side != side
    var _friendly_with = !(power(2, side) & inst.friendly_with)
    var _side_friendly_with = !(friendly_with & power(2, inst.side))
    return _side and _friendly_with and _side_friendly_with
}

function CanAttack(inst) {
    return (inst.is_flying and is_shooter) or !inst.is_flying
}

function RandomPlaceRect(x0, y0, x1, y1, inst, avoid_object=noone, avoid_attempts=3) {
    var randx = irandomer(x0, x1)
    var randy = irandomer(y0, y1)
    with inst {
        x = randx()
        y = randy()
		if (avoid_object) {
            repeat avoid_attempts {
                if !place_meeting(x, y, avoid_object) {
                    return true
                }
                x = randx()
                y = randy()
            }
            return false
        }
    }
    return true
}

function RandomSpawnRect(x0, y0, x1, y1, num, obj, avoid_object=noone, avoid_attempts=3) {
    var failed = 0
    repeat(num) {
        var inst = instance_create_layer(0, 0, "Instances", obj)
        if !RandomPlaceRect(x0, y0, x1, y1, inst, avoid_object, avoid_attempts) {
            instance_destroy(inst)
            failed++
        } else if object_is_ancestor(inst.object_index, oEntity) {
            inst.position.set(inst.x, inst.y)
            inst.move_target.set(inst.x, inst.y)
        }
    }
    return failed
}

function RectInstanceCount(x0, y0, x1, y1, obj) {
    var list = ds_list_create()
    var count = collision_rectangle_list(x0, y0, x1, y1, obj, false, false, list, false)
    ds_list_destroy(list)
    return count
}

function InstanceDeactivate(inst, caller=noone) {
    var caller_log = ""
    if caller != noone and instance_exists(inst) 
            and ((inst.object_index == oBuddy) or (inst.object_index == oArcherBuddy)) 
            and caller != oShip {
        var test = true
    }
    if instance_exists(caller) {
        caller_log = $"caller: {object_get_name(caller.object_index)}"
    } else {
        caller_log = $"caller: {caller}"
    }
    var inst_log = inst
    if instance_exists(inst) {
        inst_log = $"{object_get_name(inst.object_index)}"
    }
    // show_debug_message($"InstanceDeactivate: {inst_log} {caller_log}")
    instance_deactivate_object(inst)
}

function InstanceActivate(inst, caller=noone) {
    instance_activate_object(inst)
    var caller_log = ""
    if caller != noone and instance_exists(inst) 
            and ((inst.object_index == oBuddy) or (inst.object_index == oArcherBuddy)) 
            and caller != oShip {
        var test = true
    }
    if instance_exists(caller) {
        caller_log = $"caller: {object_get_name(caller.object_index)}"
    } else {
        caller_log = $"caller: {caller}"
    }
    var inst_log = inst
    if instance_exists(inst) {
        inst_log = $"{object_get_name(inst.object_index)}"
    }
    // show_debug_message($"InstanceDeactivate: {inst_log} {caller_log}")
}

