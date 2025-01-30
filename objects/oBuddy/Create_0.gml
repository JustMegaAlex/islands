/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

hit_sounds = global.player_hit_sfx

sprite_index = choose(sBuddy1, sBuddy2, sBuddy3, sBuddy4, sBuddy5)
hit_effect_color = global.player_hit_effect_color
hit_effect_alpha = global.player_hit_effect_alpha

side = EntitySide.ours
SetFriendlyWith(EntitySide.neutral)

default_color = c_fuchsia
default_rect.set(20, 70)

is_creature = true
is_miner = true

hp_max = 4
sp_max = 2
attack_damage = 1

death_sound = sfxCrewDeath
