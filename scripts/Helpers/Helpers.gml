
function IsCrew(inst) {
    return inst.is_creature and inst.object_index != oShip // and is our side
}

function FlyingInstDist(inst) {
    return point_distance(x, y + z, inst.x, inst.y + inst.z)
}
function FlyingInstDir(inst) {
    return point_direction(x, y + z, inst.x, inst.y + inst.z)
}
