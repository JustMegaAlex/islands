entities = []
trade_points = []
scan_revealed_counter = 0
scan_in_vision = false

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
        if !instance_exists(ent) {
            return false
        }
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

function ScanReveal(update_counter=true) {
    if scan_revealed_counter and update_counter {
		scan_revealed_counter++
        return
    }
	if update_counter {
		scan_revealed_counter++
	}
    layer = layer_get_id("ScanningIslands")
    var lay = layer_get_id("Scanning")
    image_alpha = 0.3
    for (var i = 0; i < array_length(entities); ++i) {
        var item = entities[i]
        if instance_exists(item) and (item.is_resource) {
            item.layer = lay
            item.depth_lock = true
            item.image_alpha = 0.3
        }
    }
    for (var i = 0; i < array_length(trade_points); ++i) {
        var item = trade_points[i]
		if instance_exists(item) {
	        item.depth_lock = true
	        item.layer = lay
	        item.image_alpha = 0.3
		}
    }
}

function ScanHide(update_counter=true) {
    if !scan_revealed_counter {
        return
    }
	if update_counter {
		scan_revealed_counter--	
	}
    //// Don't hide, if triggered by a tower destruction, while there are other towers in radius
	if scan_revealed_counter and update_counter {
		return
	}
    //// Don't hide again when the last tower was destroyed, if already hidden by being in player vision
	if scan_in_vision and !scan_revealed_counter {
		scan_in_vision = false
		return
	}
    layer = layer_get_id("Bottom")
    var lay = layer_get_id("Instances")
    image_alpha = 1
    for (var i = 0; i < array_length(entities); ++i) {
        var item = entities[i]
        if !instance_exists(item) {
			continue
        }
        if (item.is_resource) {
            item.layer = lay
            item.depth_lock = false
            item.image_alpha = 1
        }
    }
    for (var i = 0; i < array_length(trade_points); ++i) {
        var item = trade_points[i]
        if !instance_exists(item) {
			continue
        }
        item.layer = lay
        item.image_alpha = 1
        item.depth_lock = false
    }
}
