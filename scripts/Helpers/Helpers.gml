
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

function IsEnemySide(inst) {
    return inst.side != side and !(side & inst.friendly_with) and !(friendly_with & inst.side)
}

function RandomSpawnRect(x0, y0, x1, y1, num, obj, avoid_object=noone, avoid_attempts=3) {
    var randx = irandomer(x0, x1)
    var randy = irandomer(y0, y1)
    var avoided = false
    repeat(num) {
        var inst = instance_create_layer(randx(), randy(), "Instances", obj)
        if (avoid_object) {
            avoided = false
            with inst {
                repeat avoid_attempts {
                    if !place_meeting(x, y, avoid_object) {
                        avoided = true
                        break
                    }
                    x = randx()
                    y = randy()
                }
                if !avoided {
                    instance_destroy()
                }
            }
        }
    }
}

function RectInstanceCount(x0, y0, x1, y1, obj) {
    var list = ds_list_create()
    var count = collision_rectangle_list(x0, y0, x1, y1, obj, false, false, list, false)
    ds_list_destroy(list)
    return count
}
