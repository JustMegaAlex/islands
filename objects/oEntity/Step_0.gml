
if is_miner {
    var test = true
}
if is_creature {
    var test = false
}
if is_resource {
    var test = false
}

if hp <= 0 {
    Die(); exit
}

if IsMoving() {
    velocity.set_polar(sp_max, position.angle_to(move_target))
} else {
    velocity.set(0, 0)
}

position.add(velocity)

x = position.x
y = position.y

if !island {
    island = instance_place(x, y, oIsland)
}

//// AI
if !is_flying and !island {
    Die()
	exit
}

if is_miner {
    if !resource_to_mine or !instance_exists(resource_to_mine) {
        resource_to_mine = GetClosestInstanceFromArray(island.GetResources())
        move_target.setv(resource_to_mine.position)
    }

    if resource_to_mine {
        if position.dist_to(resource_to_mine.position) < 10 {
            StartAttacking(resource_to_mine)
        }
    }
}

if attack_target {
    if !attack_timer.update() {
        attack_target.Hit(id)
        if instance_exists(attack_target) {
            attack_timer.reset()
        } else {
            attack_target = noone
        }
    }
}
