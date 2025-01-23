
if oInput.Pressed("rclick") {
    oShip.move_target.set(mouse_x, mouse_y)
    is_ship_navigating = true
}

if !active_ui and oInput.Pressed("lclick") {
    /// Destroy a mark, mark crew to pick up, or nivagate the ship
    var mark = MouseCollision(oUIMarkDrop)
    if mark {
        instance_destroy(mark)
    } else {
        MouseCollisionInstances(
            function(inst) {
                if IsCrew(inst) {
                    inst.marked_for_pickup = !inst.marked_for_pickup; return true}
                if inst.is_resource {
                    inst.marked_for_mining = !inst.marked_for_mining; return true}
				if inst.object_index == oBuildingGuardTower {
					inst.MarkForCrew()}
                return false
            }
        )
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
        if active_ui {
            active_ui.command.deactivate()
        }
        _ui.command.activate()
        active_ui = _ui
        clicked_on_ui = true
    }
}
/// Preform button
if active_ui and !clicked_on_ui {
    if oInput.Pressed("lclick") {
        active_ui.command.press()
        // active_ui.active = false
        // active_ui = noone
    } else if oInput.Hold("lclick") {
        active_ui.command.hold()
    } else if oInput.Released("lclick") {
        active_ui.command.release()
    }
}

if !_ui {
    _ui = collision_point(mouse_x, mouse_y, oUIMapButtonParent, false, false)
    if _ui {
        _ui.mouse_over = true
        if oInput.Pressed("lclick") {
            if _ui.command.press() {
                instance_destroy(_ui)
            }
        }
    }
}

if oInput.Pressed("escape") and active_ui {
    active_ui.command.deactivate()
    active_ui = noone
}
