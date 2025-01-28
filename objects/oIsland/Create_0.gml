entities = []
trade_points = []
scan_revieled_counter = 0

function AddTradePoint(inst) {
    array_push(trade_points, inst)
}

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

function ScanReveal() {
    if InstDist(oShip) <= oPlayerVision.vision_range or scan_revieled_counter {
        return
    }
    scan_revieled_counter++
    layer = layer_get_id("ScanningIslands")
    var lay = layer_get_id("Scanning")
    image_alpha = 0.3
    for (var i = 0; i < array_length(entities); ++i) {
        var item = entities[i]
        if (item.is_resource) {
            item.layer = lay
            item.image_alpha = 0.3
        }
    }
    for (var i = 0; i < array_length(trade_points); ++i) {
        var item = trade_points[i]
        item.layer = lay
        item.image_alpha = 0.3
    }
}

function ScanHide() {
    if !scan_revieled_counter {
        return
    }
    scan_revieled_counter--
    layer = layer_get_id("Bottom")
    var lay = layer_get_id("Instances")
    image_alpha = 1
    for (var i = 0; i < array_length(entities); ++i) {
        var item = entities[i]
        if (item.is_resource) {
            item.layer = lay
            item.image_alpha = 1
        }
    }
    for (var i = 0; i < array_length(trade_points); ++i) {
        var item = trade_points[i]
        item.layer = lay
        item.image_alpha = 1
    }
}
