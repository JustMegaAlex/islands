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
