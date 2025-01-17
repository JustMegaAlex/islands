
if IsMoving() {
    velocity.set_polar(sp_max, position.angle_to(move_target))
} else {
    velocity.set(0, 0)
}

position.add(velocity)

x = position.x
y = position.y
