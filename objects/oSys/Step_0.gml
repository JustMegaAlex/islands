
DebugDrawUpdate()

if keyboard_check_pressed(ord("R")) {
    room_restart()
}

if keyboard_check_pressed(vk_f1) {
    show_debug_overlay(!is_debug_overlay_open())
}
