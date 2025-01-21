//// If no sprite, draw a rectangle
default_color = c_white
default_rect = new Vec2(100, 100)
sprite_index = sprite_index == -1 ? sWhitePixel : sprite_index

shadow_size = sprite_width
z = 0

velocity = new Vec2(0, 0)
position = new Vec2(x, y)
move_target = new Vec2(x, y)
sp_max = 1

enum EntitySide {
    ours, theirs, nature
}

hp = 1

side = EntitySide.nature

//// Type attributes
is_hidden = false
is_resource = false
is_creature = false
is_miner = false
is_fighter = false
is_flying = false
is_swimmer = false

//// State attributes
attack_target = noone
attack_target_move = noone
attack_distance = 50
enemy_detection_range = 1000
attack_timer = MakeTimer(60)
attack_damage = 1
island = noone
resource_to_mine = noone
attack_timer = MakeTimer(60)
resource_type = noone

instances_list = ds_list_create()

marked_for_pickup = false
marked_for_mining = false

function MakeHidden() {
    is_hidden = true
    image_xscale = 0
    image_yscale = 0
}

function MakeUnhidden() {
    is_hidden = false
    alarm[0] = 1
}

function StartAttacking(entity) {
    attack_target = entity
    attack_timer.reset()
}

function FindAttackTarget() {
    var count = collision_circle_list(
        x, y, enemy_detection_range, oEntity, false, false,
        instances_list, false)
    var result = noone
    var dist = infinity
    for (var i = 0; i < ds_list_size(instances_list); ++i) {
        var inst = instances_list[| i]
        if inst.is_creature
                and inst.side != EntitySide.nature 
                and inst.side != side
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
    hp -= id.damage
}

function Die() {
	if island {
		island.RemoveEntity(id)
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

alarm[0] = 1

//AttachToIsland()
