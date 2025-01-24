

if place_meeting(x, y, oShip) {
    for (var i = 0; i < array_length(ui_elements); ++i) {
        var item = ui_elements[i]
        instance_activate_object(item)
    }
    
    instance_destroy()
}