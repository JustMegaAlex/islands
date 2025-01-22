
visible = true

var sec = 60
spawn_timer = MakeTimer(5 * sec)
spawn_distance = 4000
spawn_randomer = irandomer(2, 4)
side = EntitySide.theirs
friendly_with = EntitySide.nature

enemy_nearby = noone

check_timer = MakeTimer(60)

instances_list = ds_list_create()
