
function IsCrew(inst) {
    return inst.is_creature and inst.object_index != oShip // and is our side
}
