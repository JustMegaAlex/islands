

if place_meeting(x, y, oShip) {
    for (var i = 0; i < array_length(ui_elements); ++i) {
        var obj = ui_elements[i]
        instance_activate_object(obj)
        show_debug_message($"Activated UI element {object_get_name(obj)}")
    }
    
    instance_destroy()
}