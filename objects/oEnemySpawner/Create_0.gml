
visible = true

var sec = 60
spawn_timer = MakeTimer(irandom_range(5, 10) * sec)
between_spawns_timer = MakeTimer(1.5 * sec)
spawn_distance = 3000
spawn_number = irandom_range(2, 4)
side = EntitySide.theirs
friendly_with = EntitySide.nature

enemy_nearby = noone

check_timer = MakeTimer(60)

instances_list = ds_list_create()
