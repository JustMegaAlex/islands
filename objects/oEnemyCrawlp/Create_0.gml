/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

hit_sounds = global.enemy_hit_sfx

side = EntitySide.theirs

default_color = c_black
default_rect.set(30, 50)

is_creature = true
is_fighter = true
is_swimmer = true

ai_random_walk = true

hp_max = 2
sp_max = 2
attack_damage = 1

death_sound = sfxSmallmonsterdeath

enemy_detection_range = 500
