
if oInput.Pressed("rclick") {
    oShip.move_target.set(mouse_x, mouse_y)
    is_ship_navigating = true
}

if is_ship_navigating {
    is_ship_navigating = oShip.IsMoving()
}

if oInput.Pressed("lclick") {
    instance_create_layer(mouse_x, mouse_y, "Instances", oBuddy)
}
