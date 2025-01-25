

rclick_pressed_timer.update()
lclick_pressed_timer.update()

if oInput.Pressed("rclick") {
    rclick_pressed_timer.reset()
    crew_select_box.x0 = mouse_x
    crew_select_box.y0 = mouse_y
}

if oInput.Pressed("lclick") {
    lclick_pressed_timer.reset()
    resource_select_box.x0 = mouse_x
    resource_select_box.y0 = mouse_y
}

var rclick_pressed = false
if oInput.Released("rclick") {
    rclick_pressed = rclick_pressed_timer.timer > 0
    if crew_select_box.enabled {
        RectCollisionInstances(
            crew_select_box.x0, crew_select_box.y0, crew_select_box.x1, crew_select_box.y1,
            function(inst) {
                if IsCrew(inst) {
                    inst.marked_for_pickup = !inst.marked_for_pickup; return false}
            }
        )
    }
    crew_select_box.enabled = false
}


var lclick_pressed = false
if oInput.Released("lclick") {
    lclick_pressed = lclick_pressed_timer.timer > 0
    if resource_select_box.enabled {
        RectCollisionInstances(
            resource_select_box.x0, resource_select_box.y0, resource_select_box.x1, resource_select_box.y1,
            function(inst) {
                if IsCrew(inst) {
                    inst.marked_for_pickup = !inst.marked_for_pickup; return false}
            }
        )
        // RectCollisionInstances(
        //     resource_select_box.x0, resource_select_box.y0, resource_select_box.x1, resource_select_box.y1,
        //     function(inst) {
        //         if inst.is_resource {
        //             inst.marked_for_mining = !inst.marked_for_mining; return false}
        //     }
        // )
    }
    resource_select_box.enabled = false
}

if rclick_pressed_timer.timer <= 0 and oInput.Hold("rclick") {
    crew_select_box.enabled = true
    crew_select_box.x1 = mouse_x
    crew_select_box.y1 = mouse_y
}

if !active_ui and lclick_pressed_timer.timer <= 0 and oInput.Hold("lclick") {
    resource_select_box.enabled = true
    resource_select_box.x1 = mouse_x
    resource_select_box.y1 = mouse_y
}

if rclick_pressed {
    if oInput.Hold("alter") {
        MouseCollisionInstances(
            function(inst) {
                if IsCrew(inst) {
                    inst.marked_for_pickup = !inst.marked_for_pickup; return true}
            }
        )
    } else {
        oShip.move_target.set(mouse_x, mouse_y)
        is_ship_navigating = true
    }
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

//// Check for map buttons
if !_ui {
    _ui = collision_point(mouse_x, mouse_y, oUIMapButtonParent, false, false)
    if _ui {
        _ui.mouse_over = true
        if oInput.Pressed("lclick") {
            _ui.command.press()
        }
    }
}


if !active_ui and lclick_pressed {
    /// Destroy a mark, mark crew to pick up, or nivagate the ship
    var mark = MouseCollision(oUIMarkDrop)
    if mark {
        instance_destroy(mark)
    } else {
        MouseCollisionInstances(
            function(inst) {
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


if oInput.Pressed("escape") and active_ui {
    active_ui.command.deactivate()
    active_ui = noone
}
