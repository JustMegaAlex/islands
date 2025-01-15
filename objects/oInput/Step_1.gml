
//// Reset all keys in mapping
var keys = variable_struct_get_names(mapping)
for (var i = 0; i < array_length(keys); ++i) {
    var key = keys[i]
    var key_actions = mapping[$ key]
    var action_names = variable_struct_get_names(key_actions)
    for (var j = 0; j < array_length(action_names); ++j) {
        key_actions[$ action_names[j]] = false
    }
}


var keys = variable_struct_get_names(mapping_config)
for (var i = 0; i < array_length(keys); ++i) {
    var key = keys[i]
    var inputs = mapping_config[$ key]
    for (var j = 0; j < array_length(inputs); ++j) {
        var input = inputs[j]
        for (var k = 0; k < array_length(input.actions); ++k) {
            /// action is [action_name, function] pair
            var action = input.actions[k]
            /// if action is already defined, skip
            if mapping[$ key][$ action[0]] {
                continue
            }
            mapping[$ key][$ action[0]] = action[1]()
        }
    }
}



///// Old implementation
left_pressed = false
right_pressed = false
up_pressed = false
down_pressed = false
down = false
left = false
right = false
jump = false
jump_released = false
attack = false
any = false
gp_hinp_pressed = false
gp_vinp_pressed = false
mouse_moved = false
interact = false
reload = false
dash_pressed = false
dash_released = false
key_exit = false
lmb_pressed = false

scroll_down = false
scroll_up = false

if !active
	exit

lmb_pressed = mouse_check_button_pressed(mb_left)
lmb_released = mouse_check_button_released(mb_left)

var gp_hinp = gamepad_axis_value(0, gp_axislh)
var gp_hinp_left = gp_hinp < -gp_hinp_threshold
var gp_hinp_right = gp_hinp > gp_hinp_threshold

var gp_vinp = gamepad_axis_value(0, gp_axislv)
var gp_vinp_up = gp_vinp < -gp_vinp_threshold
var gp_vinp_down = gp_vinp > gp_vinp_threshold

left_pressed = keyboard_check_pressed(vk_left)
                    or keyboard_check_pressed(ord("A"))
                    or keyboard_check_pressed(ord("Q"))
                    or (gp_hinp_left && !gp_hinp_pressed_prev)
                    or gamepad_button_check_pressed(0, gp_padl)

right_pressed = keyboard_check_pressed(vk_right)
                    or keyboard_check_pressed(ord("D"))
                    or (gp_hinp_right && !gp_hinp_pressed_prev)
                    or gamepad_button_check_pressed(0, gp_padr)

up_pressed = (keyboard_check_pressed(vk_up))
                  or keyboard_check_pressed(ord("W"))
                  or keyboard_check_pressed(ord("Z"))
                  or (gp_vinp_up && !gp_vinp_pressed_prev)
                  or gamepad_button_check_pressed(0, gp_padu)
                  
down_pressed = (keyboard_check_pressed(vk_down))
            or keyboard_check_pressed(ord("S"))
            or (gp_vinp_down && !gp_vinp_pressed_prev)
            or gamepad_button_check_pressed(0, gp_padd)
 

up = (keyboard_check(vk_up))
                  or keyboard_check(ord("W"))
                  or (gp_vinp_up && !gp_vinp_pressed_prev)
                  or gamepad_button_check(0, gp_padu)

down = (keyboard_check(vk_down))
            or keyboard_check(ord("S"))
            or (gamepad_axis_value(0, gp_axislv) > gp_vinp_threshold)
            or gamepad_button_check(0, gp_padd)
left = keyboard_check(vk_left)
            or keyboard_check(ord("A"))
            or gp_hinp_left
            or keyboard_check(ord("Q"))
            or gamepad_button_check(0, gp_padl)
right = keyboard_check(vk_right)
            or keyboard_check(ord("D")) 
            or gp_hinp_right
            or gamepad_button_check(0, gp_padr)
jump = keyboard_check(vk_space) or gamepad_button_check(0, gp_face1)
jump_released = keyboard_check_released(vk_space) or gamepad_button_check_released(0, gp_face1)
jump_pressed = keyboard_check_pressed(vk_space) or gamepad_button_check_pressed(0, gp_face1)

attack = keyboard_check_pressed(ord("X"))
            or keyboard_check_pressed(ord("K"))
            or (gamepad_button_check_pressed(0, gp_face3))
action = attack or keyboard_check_pressed(vk_enter)
escape = keyboard_check_pressed(vk_escape)
             or gamepad_button_check_pressed(0, gp_start)

reload = keyboard_check_pressed(ord("R"))
interact = keyboard_check_pressed(ord("E"))

key_exit = keyboard_check_pressed(vk_escape)

any = keyboard_check_pressed(vk_anykey)

dash_released = keyboard_check_released(ord("C"))
dash_pressed = keyboard_check_pressed(ord("C"))


scroll_down = mouse_wheel_down()
scroll_up = mouse_wheel_up()

gp_hinp_pressed_prev = abs(gp_hinp) > gp_hinp_threshold
if (gp_hinp_pressed_prev) {
  left = abs(min(gp_hinp, 0))
  right = max(gp_hinp, 0)
}

gp_vinp_pressed_prev = abs(gp_vinp) > gp_vinp_threshold


//// Mouse
mouse_moved = mouse_x != mouse_x_prev or mouse_y != mouse_y_prev
mouse_x_prev = mouse_x
mouse_y_prev = mouse_y
