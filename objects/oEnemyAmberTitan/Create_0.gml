/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

var sec = 60

side = EntitySide.theirs

default_color = c_black
default_rect.set(30, 50)

is_creature = true
is_fighter = true
is_swimmer = true

ai_random_walk = true

hp_max = 100
sp_max = 0.5
attack_damage = 0
attack_distance = 1000

harpies_swarm = {
    number: 10,
    timer: MakeTimer(30 * sec),
    trigger_distance: 1000,
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
        harpy.attack_distance = harpies_swarm.trigger_distance + 200
    }
}
