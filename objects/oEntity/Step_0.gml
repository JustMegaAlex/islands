
if is_miner {
    var test = true
}
if is_creature {
    var test = false
}
if is_resource {
    var test = false
}
var test
switch object_index {
	case oArcherBuddy:
		test = true; break
		
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


//// AI
if !is_flying and !is_swimmer {
    if !island {
        island = instance_place(x, y, oIsland)
        if !island {
            Die()
            exit
        }
    }
    x = clamp(
        x, island.bbox_left + island_collision_paddingx,
           island.bbox_right - island_collision_paddingx)
    y = clamp(
        y, island.bbox_top + island_collision_paddingy,
           island.bbox_bottom - island_collision_paddingy)
}


if is_fighter {
    var atk = attack_target ?? attack_target_move
    if !atk or !instance_exists(atk) {
        attack_target_move = FindAttackTarget()
    }
    if attack_target_move {
        if (InstDist(attack_target_move) < attack_distance) {
            if !attack_target {
                move_target.set(x, y)
                StartAttacking(attack_target_move)
            }
        } else {
            attack_target = noone
            move_target.setv(attack_target_move.position)
        }
    }
}

if is_miner and side == EntitySide.ours and !attack_target {
    if !resource_to_mine or !instance_exists(resource_to_mine) {
        resource_to_mine = GetClosestInstanceFromArray(
            array_filter(island.GetResources(), function(inst) { return inst.marked_for_mining })
        )
        if resource_to_mine {
            move_target.setv(resource_to_mine.position)
        }
    }

    if resource_to_mine {
        if position.dist_to(resource_to_mine.position) < 10 {
            if !attack_target {
                StartAttacking(resource_to_mine)
            }
        }
    }
}


if attack_target and !instance_exists(attack_target) {
    attack_target = noone
}

if attack_target {
    if !attack_timer.update() {
        if is_shooter {
            instance_create_layer(x, y, "Instances", oArrow, 
                                  { shooter: id, target: attack_target })
        } else {
            attack_target.Hit(id)
        }
        if instance_exists(attack_target) {
            attack_timer.reset()
        } else {
            attack_target = noone
        }
    }
}
