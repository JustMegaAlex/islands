/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

collision_circle_list(x, y, drop_crew_radius, oUIMarkDrop, false, false, drop_crew_marks, false)
collision_circle_list(x, y, drop_crew_radius, oEntity, false, false, crew_instances, false)


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

if ds_list_size(crew_instances) {
    for (var i = 0; i < ds_list_size(crew_instances); ++i) {
        var inst = crew_instances[| i]
        if !IsCrew(inst) or !inst.marked_for_pickup or inst.is_hidden {
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


ds_list_clear(drop_crew_marks)
ds_list_clear(crew_instances)
