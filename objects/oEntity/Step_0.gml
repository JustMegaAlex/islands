
CHECK_PAUSE

frames++
if is_flying {
    z = z_base + lengthdir_x(fly_waving_magnitude, frames * fly_waving_angular_speed)
}

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
		
	case oBuildingGuardTower:
		test = true; break
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

if object_index == oBuildingGuardTower {
	test = true
}

if is_fighter {
    var atk = attack_target ? attack_target : attack_target_move
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
            island.GetResources()
            // array_filter(island.GetResources(), function(inst) { return inst.marked_for_mining })
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

//// Override any fight or mining behavior if there is a tower marked for crew nearby
if move_to_tower and instance_exists(move_to_tower) {
    move_target.setv(move_to_tower.position)
    if InstDist(move_to_tower) < 100 {
        move_to_tower.TakeCrew(id)
        move_to_tower = noone
        move_target.set(x, y)
    }
}

if attack_target and !instance_exists(attack_target) {
    attack_target = noone
}

ai_random_walk_timer.update()

if attack_target {
    if !attack_timer.update() {
        if SpecialAttack {
            SpecialAttack()
        } else if is_shooter {
            ShootAnArrow()
        } else {
            attack_target.Hit(id)
        }
        if instance_exists(attack_target) {
            attack_timer.reset()
        } else {
            attack_target = noone
        }
    }
} else {
    if ai_random_walk and !ai_random_walk_timer.timer and !IsMoving() {
         move_target.add_polar(ai_random_walk_distance, random(360))
         ai_random_walk_timer.time = ai_random_walk_time_randomer()
         ai_random_walk_timer.reset()
    }
}

protection_aura = false
