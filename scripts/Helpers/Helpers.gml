
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