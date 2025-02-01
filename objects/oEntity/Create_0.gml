
event_inherited()

//// If no sprite, draw a rectangle
default_color = c_white
default_rect = new Vec2(100, 100)
sprite_index = sprite_index == -1 ? sWhitePixel : sprite_index

hit_blinking_timer = MakeTimer(15, 0)
hit_effect_alpha = 0.5
hit_effect_color = c_white
hit_sounds = noone

shoot_sounds = noone

frames = 0
fly_waving_angular_speed = 0.4
fly_waving_magnitude = 30

/// stay inside an island
island_collision_paddingx = sprite_width * 0.5
island_collision_paddingy = sprite_height * 0.5
shadow_size = sprite_width
z = 0
z_base = z

velocity = new Vec2(0, 0)
position = new Vec2(x, y)
sp_max = global.sp_entity_default

info_text = ""

enum EntitySide {
    __zero, ours, theirs, nature,
    neutral, rogue
}

hp_max = 1
hp = hp_max

side = EntitySide.nature
friendly_with = 0 // bitwise mask
SetFriendlyWith(EntitySide.nature)

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

death_sound = noone


function StartAttacking(entity) {
    attack_target = entity
    // attack_timer.reset()
}

function CheckUndoAttackCounter() {
    var atk = attack_target ? attack_target : attack_target_move
    if atk and instance_exists(atk) {
        atk.attackers_count = max(0, atk.attackers_count - 1)
    }
}

function DropStateAttributes() {
    CheckUndoAttackCounter()
	DetachFromIsland()
    marked_for_pickup = false
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
    var sorted_by_dist = []
    DistCompare.inst = id
    for (var i = 0; i < count; ++i) {
        var inst = instances_list[| i]
        if object_index == oEnemyHarpy and inst.object_index == oShip {
            return inst
        }
        if (inst.is_creature or inst.is_structure)
                and IsEnemySide(inst) and CanAttack(inst) {
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
    if id.object_index == oCannonCore {
        if is_flying {
            return
        }
        if side == EntitySide.ours {
            hp -= 0.2
        }
    }
    if object_index == oBuildingGuardTower {
        var test = true
    }
    hp -= id.attack_damage * (protection_aura ? 0.5 : 1)
    hit_blinking_timer.reset()
    if hit_sounds != noone {
        PlaySoundAt(x, y, ArrayChoose(hit_sounds))
    }
}

function Die() {
    CheckUndoAttackCounter()
	if island {
		island.RemoveEntity(id)
	}
	if death_sound != noone {
		PlaySoundAt(x, y, death_sound)	
	}
    instance_destroy()
}

function BuildingFinished() {}

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
    if shoot_sounds != noone {  
        PlaySoundAt(x, y, ArrayChoose(shoot_sounds))
    }
}

function Heal(amount) {
    hp = min(hp + amount, hp_max)
}

function Info() {
    return {
        text: info_text
    }
}

function DrawHitBlinking(alpha, color=c_white) {
	gpu_set_fog(true, color, 0, 0)
	draw_sprite_ext(
		sprite_index,
		image_index,
		x, y,
		image_xscale, image_yscale,
		image_angle, c_white, alpha)
	gpu_set_fog(false, color, 0, 0)
}

SpecialAttack = undefined

alarm[0] = 1

//AttachToIsland()

