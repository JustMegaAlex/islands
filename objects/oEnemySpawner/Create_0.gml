
visible = true

var sec = 60
spawn_timer = MakeTimer(20 * sec)
spawn_distance = 1000
spawn_position = new Vec2(x, y)
spawn_randomer = irandomer(2, 4)
side = EntitySide.theirs
friendly_with = EntitySide.nature
island = instance_place(x, y, oIsland)

is_enemy_near = false

check_timer = MakeTimer(24)
