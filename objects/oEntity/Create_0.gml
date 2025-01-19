//// If no sprite, draw a rectangle
default_color = c_white
default_rect = new Vec2(100, 100)
sprite_index = sprite_index == -1 ? sWhitePixel : sprite_index

shadow_size = sprite_width
z = 0

velocity = new Vec2(0, 0)
position = new Vec2(x, y)
move_target = new Vec2(x, y)
sp_max = 0

enum EntitySide {
    ours, theirs, nature
}

hp = 0

//// Type attributes
is_resource = false
is_creature = false
is_miner = false
is_fighter = false
is_flying = false

//// State attributes

attack_target = noone
attack_timer = MakeTimer(60)
attack_damage = 0
island = instance_place(x, y, oIsland)
resource_to_mine = noone

function StartAttacking(entity) {
    attack_target = entity
    attack_timer = MakeTimer(60)
}

function IsMoving() {
    return position.dist_to(move_target) > sp_max
}

function Hit(id) {
    hp -= id.damage
}

function Die() {
    instance_destroy()
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

alarm[0] = 0
