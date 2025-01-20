
if oInput.Pressed("rclick") {
    /// Destroy a mark, mark crew to pick up, or nivagate the ship
    var mark = MouseCollision(oUIMarkDrop)
    if mark {
        instance_destroy(mark)
    } else {
        if !MouseCollisionInstances(
            function(inst) {
                if IsCrew(inst) {
                    inst.marked_for_pickup = !inst.marked_for_pickup; return true
                }; return false
            }
        ) {
            oShip.move_target.set(mouse_x, mouse_y)
            is_ship_navigating = true
        }
    }
}

if is_ship_navigating {
    is_ship_navigating = oShip.IsMoving()
}



///// UI
mx = window_mouse_get_x(); my = window_mouse_get_y();
var _ui = collision_point(mx, my, oUIButtonParent, false, false)
var clicked_on_ui = false
if _ui {
    _ui.mouse_over = true
    if oInput.Pressed("lclick") {
        _ui.active = true
        active_ui = _ui
        clicked_on_ui = true
    }
}
/// Preform button
if active_ui and !clicked_on_ui {
    if oInput.Pressed("lclick") {
        active_ui.command.perform()
        // active_ui.active = false
        // active_ui = noone
    }
}
