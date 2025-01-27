
visible = true

var sec = 60
spawn_timer = MakeTimer(irandom_range(5, 10) * sec)
between_spawns_timer = MakeTimer(1.5 * sec)
spawn_distance = 3000
spawn_number = oGen.enemy_spawn.crawlp.count_per_spawn
side = EntitySide.theirs
friendly_with = 0
SetFriendlyWith(EntitySide.nature)
is_spawning = false

enemy_nearby = noone

check_timer = MakeTimer(60)

instances_list = ds_list_create()
