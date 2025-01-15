
button_obj = oRoomLoaderButton
button_scale = 1.5
button_column_nubmer = 5
// settle up rooms buttons
room_count = 0
buttons_count = 0

banned_rooms = [
	rm_Aura_Demo, rm_Aura_Dynamic, rm_Aura_Static,
	rmRoomLoader,
]

banned_rooms = array_map(banned_rooms, real)

while room_exists(room_count) {
    room_count++
	if !array_contains(banned_rooms, real(room_count)) {
		buttons_count++	
	}
}

var columns = buttons_count div button_column_nubmer
var y_delta = sprite_get_height(object_get_sprite(button_obj)) + 10
var xgap = 30
var x_delta = sprite_get_width(object_get_sprite(button_obj)) * button_scale + xgap
var but_y_st = 100
var but_x_st = CamW() * 0.5 - x_delta * (columns - 1) * 0.5
var room_ind = -1
var button_count = -1
repeat room_count {
    room_ind++
    if room_ind == room {
        continue
    }
	if array_contains(banned_rooms, room_ind) {
		continue	
	}
    button_count++
    var row = button_count mod button_column_nubmer
    var col = button_count div button_column_nubmer
    var btn = instance_create_layer(
                    but_x_st + col * x_delta,
                    but_y_st + row * y_delta,
                    "Instances", button_obj, {image_xscale: button_scale})
    btn.room_to_start = room_ind
}


// if only one room start immidiately
if room_count == 1
	room_goto(1)
