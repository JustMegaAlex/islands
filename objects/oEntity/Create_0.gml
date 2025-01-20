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

//// Type attributes
is_hidden = false
is_resource = false
is_creature = false
is_miner = false
is_fighter = false
is_flying = false

//// State attributes
attack_target = noone
attack_timer = MakeTimer(60)
attack_damage = 1
island = noone
resource_to_mine = noone
attack_timer = MakeTimer(60)
resource_type = noone

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

function IsMoving() {
    return position.dist_to(move_target) > sp_max
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
