
////// Update active grid areas
var shipv = oGen.ship_grid_pos
for (var i = -grid_active_distance; i < grid_active_distance+1; ++i) {
    for (var j = -grid_active_distance; j < grid_active_distance+1; ++j) {
        vec_check.set(shipv.x + i, shipv.y + j)
        if oGen.GridCheck(vec_check) {
            var area = oGen.GridGet(vec_check)
            if area.is_activated {
                continue
            }
            AreaActivate(area)
        }
    }
}

for (var i = 0; i < array_length(active_areas); ++i) {
    var area = active_areas[i]
    if GridDist(area.i, area.j, shipv.x, shipv.y) > grid_active_distance {
        AreaDeactivate(area)
    }
}

with oWorldEntity {
    if object_index == oBuildingWatchTower {
        continue
    }
    var _area = oGen.GridGetByCoords(x, y)
    if _area != world_grid_area {
        other.MoveToArea(id, _area)
    }
	if !world_grid_area.is_activated {
		show_debug_message($"deactivating {id} of {object_get_name(id.object_index)}")
	    InstanceDeactivate(id, id)
	}
}



///// Running instances
CHECK_PAUSE
repeat max_instances_per_step {
    var inst = instance_find(oEntity, current_instance_index)
    with inst { event_user(1) }
    current_instance_index = (current_instance_index + 1) % instance_number(oEntity)
}
