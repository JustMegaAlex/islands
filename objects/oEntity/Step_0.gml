
//if object_index != oShip { exit }

event_inherited()

CHECK_PAUSE

frames++
if is_flying {
    z = z_base + lengthdir_x(fly_waving_magnitude, frames * fly_waving_angular_speed)
}


if is_structure and build_timer.timer {
    if !build_timer.update() {
        BuildingFinished()
    } else {
        exit
    }
} else {
    image_alpha = 1
}

if hp <= 0 {
    Die(); exit;
}

if IsMoving() {
    velocity.set_polar(sp_max, position.angle_to(move_target))
} else {
    velocity.set(0, 0)
}
if !is_structure {
    position.add(velocity)
}

if velocity.x != 0 {
    image_xscale = image_xscale_start * sign(velocity.x)
}

x = position.x
y = position.y


