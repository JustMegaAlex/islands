/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

var sec = 60

side = EntitySide.theirs

default_color = c_black
default_rect.set(30, 50)

image_xscale = 2
image_yscale = 2

is_creature = true
is_fighter = true
is_swimmer = true

ai_random_walk = true

hp_max = 100
sp_max = 0.75
attack_damage = 0
attack_distance = 500

harpies_swarm = {
    number: 10,
    timer: MakeTimer(27 * sec),
    trigger_distance: 1000,
}

amber_rain = {
    timer: MakeTimer(32 * sec),
    spawn_timer: MakeTimer(18),
    trigger_distance: 1200,
    number: 6,
    number_to_spawn: 0,
    area_size: 300,
    target: noone,
    z: -400
}

function FindAttackTarget() {
    return oShip
}

function HarpiesSwarm() {
    repeat(harpies_swarm.number) {
        var harpy = instance_create_layer(
            x + random_range(-200, 200), 
            y + random_range(-200, 200), 
            "Instances", oEnemyHarpy)
        harpy.enemy_detection_range = harpies_swarm.trigger_distance + 200
    }
}

function AmberRain() {
    var randx = irandomer(amber_rain.target.x-amber_rain.area_size, amber_rain.target.x+amber_rain.area_size)
    var randy = irandomer(amber_rain.target.y-amber_rain.area_size, amber_rain.target.y+amber_rain.area_size)
    var rand_angle = irandomer(210, 240)
    var rain = instance_create_layer(randx(), randy(), "Instances", oAmberRain)
    rain.Launch(amber_rain.z, rand_angle())
}

function FindAmberRainTarget() {
    arr = EntitiesInCircle(x, y, amber_rain.trigger_distance, IsEnemySide)
    if ArrayEmpty(arr) { return noone }
    var max_count = 0
    var target = noone
    while !ArrayEmpty(arr) {
        var ent = array_shift(arr)
        var _arr = EntitiesInCircle(ent.x, ent.y, amber_rain.area_size, IsEnemySide)
        if array_length(_arr) > max_count {
            max_count = array_length(_arr)
            target = ent
            for (var j = 0; j < array_length(_arr); ++j) {
                var item = _arr[j]
                ArrayRemove(arr, item)
            }
        }
    }
    return target
}
