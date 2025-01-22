
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
    collision_circle_list(x, y, r, oEntity, false, false, list, false)
}

function IsEnemySide(inst) {
    return !(side & inst.friendly_with) and !(friendly_with & inst.side)
}

function RandomSpawnRect(x0, y0, x1, y1, num, obj, avoid_object, avoid_attempts=3) {
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
