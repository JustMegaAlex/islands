/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

fly_waving_angular_speed = 0.6
fly_waving_magnitude = 15

hit_sounds = global.enemy_hit_sfx

image_xscale = 2
image_yscale = 2

side = EntitySide.theirs

default_color = c_black
default_rect.set(50, 40)

is_creature = true
is_fighter = true
is_flying = true
is_shooter = true

ai_random_walk = true
ai_random_walk_distance = 500

hp_max = 4
sp_max = global.harpy_sp_max
attack_damage = 1
attack_timer.time = 90

attack_distance = 400
enemy_detection_range = 800

z = -200
