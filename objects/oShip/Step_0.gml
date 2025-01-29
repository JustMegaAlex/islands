CHECK_PAUSE

event_inherited()

collision_circle_list(x, y, drop_crew_radius, oUIMarkDrop, false, false, drop_crew_marks, false)
collision_circle_list(x, y, drop_crew_radius, oEntity, false, false, crew_instances, false)
collision_circle_list(x, y, drop_crew_radius, oCollectibleParent, false, false, collectibles, false)


//// Drop crew
if ds_list_size(drop_crew_marks) {
    for (var i = 0; i < ds_list_size(drop_crew_marks); ++i) {
        var item = drop_crew_marks[| i]
        var crew_arr = crew[$ item.crew_type]
        if !ArrayEmpty(crew_arr) {
            DropCrew(item.crew_type, item.x, item.y)
            instance_destroy(item)
        }
    }
}

//// Pickup crew
if ds_list_size(crew_instances) {
    for (var i = 0; i < ds_list_size(crew_instances); ++i) {
        var inst = crew_instances[| i]
        if !IsCrew(inst) or !inst.marked_for_pickup {
            continue
        }

        var crew_arr = crew[$ object_get_name(inst.object_index)]
		if crew_arr == undefined {
			show_debug_message($"Not found crew array for {object_get_name(inst.object_index)}")
		}
        inst.marked_for_pickup = false
        LoadCrew(inst)
    }
}

//// Pickup collectibles
if ds_list_size(collectibles) {
    for (var i = 0; i < ds_list_size(collectibles); ++i) {
        var item = collectibles[| i]
        item.is_collected = true
    }
}

//// Clear lists
ds_list_clear(drop_crew_marks)
ds_list_clear(crew_instances)
ds_list_clear(collectibles)

var entities = undefined
if amber_wrath_timer.timer > 0 {
    if !amber_wrath_timer.update() {
        sp_max = sp_initial
    }
    entities = EntitiesInCircle(x, y, 100, function(ent) { return ent.object_index != oShip })
    for (var i = 0; i < array_length(entities); ++i) {
        var ent = entities[i]
        ent.Hit(amber_wrath_struct)
    }
}

if heal_aura_timer.timer > 0 {
    if heal_aura_timer.update() {
        entities = entities ?? EntitiesInCircle(x, y, 100)
        for (var i = 0; i < array_length(entities); ++i) {
            var ent = entities[i]
            if !IsCrew(ent) and ent.object_index == oShip {
                continue
            }
            ent.Heal(ent.hp_max / 180)
        }
    }
}

if protection_aura_timer.timer > 0 {
    if protection_aura_timer.update() {
        entities = entities ?? EntitiesInCircle(x, y, 100)
        for (var i = 0; i < array_length(entities); ++i) {
            var ent = entities[i]
            if !IsCrew(ent) and ent.object_index == oShip {
                continue
            }
            ent.protection_aura = true
        }
    }
}

if speed_boost_timer.update() {
    sp_max = sp_initial * speed_boost_multiplier
} else {
    sp_max = sp_initial
}

if repair_timer.update() {
    hp += repair_rate
}

OnBoardShooters()
