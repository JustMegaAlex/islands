
DebugDrawUpdate()

if keyboard_check_pressed(vk_f4) {
	ResetGlobals()
    room_restart()
}

if keyboard_check_pressed(vk_f1) {
    show_debug_overlay(!is_debug_overlay_open())
    //show_debug_log(true)
}
