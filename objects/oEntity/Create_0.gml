//// If no sprite, draw a rectangle
default_color = c_white
default_rect = new Vec2(100, 100)
sprite_index = sprite_index == -1 ? sWhitePixel : sprite_index

/// stay inside an island
island_collision_paddingx = sprite_width * 0.5
island_collision_paddingy = sprite_height * 0.5
shadow_size = sprite_width
z = 0

velocity = new Vec2(0, 0)
position = new Vec2(x, y)
sp_max = global.sp_entity_default

enum EntitySide {
    ours, theirs, nature,
    neutral, rogue
}

hp_max = 1
hp = 1

side = EntitySide.nature
friendly_with = EntitySide.nature // bitwise mask

//// Type attributes
is_resource = false
is_creature = false
is_miner = false
is_fighter = false
is_flying = false
is_swimmer = false
is_structure = false
is_shooter = false

//// State attributes
attack_target = noone
attack_target_move = noone
move_target = new Vec2(x, y)
attack_timer = MakeTimer(60)
island = noone
resource_to_mine = noone
build_timer = MakeTimer(10 * 60)
move_to_tower = noone
settlement = noone

//// Stats
attack_distance = 50
enemy_detection_range = 1000
attack_damage = 1
resource_type = noone

instances_list = ds_list_create() /// helper list for _collision_list functions

marked_for_pickup = false
marked_for_mining = false

function StartAttacking(entity) {
    attack_target = entity
    attack_timer.reset()
}

function DropStateAttributes() {
    attack_target = noone
    attack_target_move = noone
    attack_timer.reset()
    move_target.setv(position)
    island = noone
    resource_to_mine = noone
}

function FindAttackTarget() {
    var count = collision_circle_list(
        x, y, enemy_detection_range, oEntity, false, false,
        instances_list, false)
    var result = noone
    var dist = infinity
    for (var i = 0; i < ds_list_size(instances_list); ++i) {
        var inst = instances_list[| i]
        if (inst.is_creature or inst.is_structure)
                and IsEnemySide(inst)
                and InstDist(inst) < dist {
            result = inst
            dist = InstDist(inst)
        }
    }
    ds_list_clear(instances_list)
    return result
}

function IsMoving() {
    return move_target and position.dist_to(move_target) > sp_max
}

function Hit(id) {
    if id.object_index == oCannonCore and is_flying {
        return
    }
    hp -= id.attack_damage
}

function Die() {
	if island {
		island.RemoveEntity(id)
	}
    if settlement and instance_exists(settlement) {
        settlement.RemoveUnit(id)
    }
    instance_destroy()
}

function SetPos(xx, yy=undefined) {
    if yy == undefined {
        position.set(xx.x, xx.y); x = xx.x; y = xx.y
		return
    }
    position.set(xx, yy); x = xx; y = yy
}

function AttachToIsland() {
	island = instance_place(x, y, oIsland)
	if island {
		island.AddEntity(id)	
	}
}

function DetachFromIsland() {
	if island {
		island.RemoveEntity(id)
		island = noone
	}
}

function GetClosestInstanceFromArray(array) {
    if ArrayEmpty(array) { return noone }
    var closest = array[0]
    for (var i = 0; i < array_length(array); i++) {
        if (array[i].position.dist_to(position) < closest.position.dist_to(position)) {
            closest = array[i]
        }
    }
    return closest
}

function ShootAnArrow() {
    instance_create_layer(x, y, "Instances", oArrow, 
                          { shooter: id, target: attack_target })
}

SpecialAttack = undefined

alarm[0] = 1

//AttachToIsland()
