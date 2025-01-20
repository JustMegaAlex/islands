/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

collision_circle_list(x, y, drop_crew_radius, oUIMarkDrop, false, false, drop_crew_marks, false)


//// Drop crew
if ds_list_size(drop_crew_marks) {
    for (var i = 0; i < ds_list_size(drop_crew_marks); ++i) {
        var item = drop_crew_marks[| i]
        var crew_arr = crew[$ item.crew_type]
        if !ArrayEmpty(crew_arr) {
            var inst = array_pop(crew_arr)
            inst.SetPos(item.x, item.y)
            inst.MakeUnhidden()
            instance_destroy(item)
        }
    }
}


ds_list_clear(drop_crew_marks)
