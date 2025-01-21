
visible = false

var sec = 60
spawn_timer = MakeTimer(3 * sec)
spawn_distance = 1000
spawn_position = new Vec2(x, y)
spawn_randomer = irandomer(2, 4)
list_instances = ds_list_create()
side = EntitySide.theirs
island = instance_place(x, y, oIsland)

is_enemy_near = false

check_timer = MakeTimer(24)
