/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

hit_sounds = global.player_hit_sfx

hit_effect_color = global.player_hit_effect_color
hit_effect_alpha = global.player_hit_effect_alpha

side = EntitySide.ours
SetFriendlyWith(EntitySide.neutral)

default_color = c_green
default_rect.set(20, 70)

is_creature = true
is_fighter = true
is_shooter = true

attack_distance = 400

hp_max = 2
sp_max = 2
attack_attack_damage = 1

death_sound = sfxCrewDeath
