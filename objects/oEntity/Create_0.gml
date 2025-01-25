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
hp = hp_max

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
ai_random_walk = false
ai_random_walk_timer = MakeTimer(3 * 60)
ai_random_walk_distance = 40
ai_random_walk_time_randomer = irandomer(2 * 60, 4 * 60)
attack_distance = 50
enemy_detection_range = 1000
attack_damage = 1
wood = 0
amber = 0

protection_aura = false

attackers_count = 0

instances_list = ds_list_create() /// helper list for _collision_list functions

marked_for_pickup = false
marked_for_mining = false

function StartAttacking(entity) {
    attack_target = entity
    attack_timer.reset()
}

function CheckUndoAttackCounter() {
    var atk = attack_target ? attack_target : attack_target_move
    if atk and instance_exists(atk) {
        atk.attackers_count--
    }
}

function DropStateAttributes() {
    CheckUndoAttackCounter()
    attack_target = noone
    attack_target_move = noone
    attack_timer.reset()
    move_target.setv(position)
    island = noone
    resource_to_mine = noone
}

function _insertSorted(array, value, compare_func) {
    var i = 0
    while (i < array_length(array) and compare_func(array[i], value) < 0) {
        i++
    }
    array_insert(array, i, value)
}

DistCompare = {
    inst: noone,
    compare: function(a, b) {
        return InstInstDist(inst, a) - InstInstDist(inst, b)
    }
}

function FindAttackTarget() {
    var count = collision_circle_list(
        x, y, enemy_detection_range, oEntity, false, false,
        instances_list, false)
    var target = noone
    var dist = infinity
    var sorted_by_dist = []
    DistCompare.inst = id
    for (var i = 0; i < ds_list_size(instances_list); ++i) {
        var inst = instances_list[| i]
        if object_index == oEnemyHarpy and inst.object_index == oShip {
            target = inst
            break
        }
        if (inst.is_creature or inst.is_structure)
                and IsEnemySide(inst) {
            _insertSorted(sorted_by_dist, inst, DistCompare.compare)
        }
    }
    ds_list_clear(instances_list)
    if ArrayEmpty(sorted_by_dist) {
        return noone
    }
    for (var i = 0; i < array_length(sorted_by_dist); ++i) {
        var inst = sorted_by_dist[i]
        if (inst.attackers_count < 2) {
            inst.attackers_count++
            return inst
        }
    }
    return ArrayChoose(sorted_by_dist)
}

function CrowdAttack(target) {
    var friends = EntitiesInCircle(x, y, 150, function(ent) 
        { return ent.is_fighter and ent.side == side 
                 and !(ent.attack_target or ent.attack_target_move) })
    var enemies = EntitiesInCircle(target.x, target.y, 150, function(ent) 
        { return ent.is_creature and IsEnemySide(ent) })
    for (var i = 0; i < array_length(friends); ++i) {
        var inst = friends[i]
        inst.attack_target_move = ArrayChoose(enemies)
    }
}

function IsMoving() {
    return move_target and position.dist_to(move_target) > sp_max
}

function Hit(id) {
    if id.object_index == oCannonCore and is_flying {
        return
    }
    hp -= id.attack_damage * (protection_aura ? 0.5 : 1)
}

function Die() {
    CheckUndoAttackCounter()
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
    instance_create_layer(x, y + z, "Instances", oArrow, 
                          { shooter: id, target: attack_target })
}

function Heal(amount) {
    hp = min(hp + amount, hp_max)
}

SpecialAttack = undefined

alarm[0] = 1

//AttachToIsland()

