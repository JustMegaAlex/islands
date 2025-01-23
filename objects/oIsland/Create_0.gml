entities = []
function AddEntity(ent) {
    array_push(entities, ent)
}

function RemoveEntity(ent) {
    ArrayRemove(entities, ent)
}

function GetResources() {
    return array_filter(entities, function(ent) {
        return ent.is_resource
    })
}

function GetCreatures() {
    return array_filter(entities, function(ent) {
        return ent.is_creature
    })
}

function GetOurBuildings() {
    return array_filter(entities, function(ent) {
        return ent.is_structure and ent.side == EntitySide.ours
    })
}

function GetOurBuildingsMarkedForCrew() {
    return array_filter(entities, function(ent) {
        return ent.is_structure 
                and ent.side == EntitySide.ours
                and ent.marked_for_number_of_crew
    })
}

function GetCrew() {
    return array_filter(entities, IsCrew)
}