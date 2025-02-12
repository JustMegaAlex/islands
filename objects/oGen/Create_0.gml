
_debug_corner_cells = []

grid_w = 300
grid_h = 300

gen_enabled = false

grid_area_size = 2500
x0 = oShip.x - grid_w * grid_area_size / 2
y0 = oShip.y - grid_h * grid_area_size / 2

grid = ds_grid_create(grid_w, grid_h)
generated_areas = []
ship_grid_pos_prev = new Vec2(-infinity, -infinity)
ship_grid_pos = new Vec2(0, 0)
for (var i = 0; i < grid_w; i++) {
    for (var j = 0; j < grid_h; j++) {
        grid[# i, j] = new Area(i, j)
    }
}

var sec = 60
emerging_level = 0
emerge_timer = MakeTimer(60 * sec)
emerge_resource_gain = 0.1
resource_multiplier = 1

enemy_spawn_timer = MakeTimer(45 * sec)
enemy_spawn_sub_area_size = 200
enemy_spawn = {
    crawlp: {
        spawns: 2,
        count_per_spawn: 2,
        area_limit: 6,
    },
    harpy: {
        count_per_spawn: 0,
        area_limit: 0,
        spawns: 0,
    },
}


function Island(trees, amber, enemy_spawners=0, big_trees=0) constructor {
    self.trees = irandom_range(trees, trees * 1.5)
    self.amber = irandom_range(amber, amber * 1.5)
    self.enemy_spawners = enemy_spawners
    self.big_trees = big_trees
}

function Cell(
        islands_count=4,
        enemy_spawners=0) constructor {
    self.islands_count = islands_count
    self.enemy_spawners = enemy_spawners
    self.size_randomer = irandomer(400, 1000)

    FixIslandPlacement = function(isle) {
        var cycles = 1000
        with isle {
            while place_meeting(x, y, oIsland) {
                x = other.posx_randomer()
                y = other.posy_randomer()
                cycles--
                if (cycles <= 0) {
                    show_message($"Failed to place island at {xx}, {yy}")
                    break
                }
            }
        }
    }

    GenerateItems = function(isle, num, obj) {
        with isle {
            var gap = 20
            var placex_randomer = irandomer(bbox_left + gap, bbox_right - gap)
            var placey_randomer = irandomer(bbox_top + gap, bbox_bottom - gap)
            repeat(num) {
                var inst = instance_create_layer(
                    placex_randomer(), placey_randomer(), "Instances", obj)
                var cycles = 1000
                with inst while true {
                    var ent = instance_place(x, y, oEntity)
                    if !ent or !ent.is_resource or !ent.is_structure {
                        break
                    }
                    x = placex_randomer()
                    y = placey_randomer()
                    cycles--
                    if (cycles <= 0) {
                        show_message($"Failed to place tree at {inst.x}, {inst.y}")
                        break
                    }
                }
            }
        }
    }

    FillIsland = function(isle, gen, trade_point) {
        if trade_point {
            if object_exists(trade_point) {
                GenerateItems(isle, 1, trade_point)
            } else {
                var gap = 20
                RandomPlaceRect(
                    isle.bbox_left + gap, isle.bbox_top + gap,
                    isle.bbox_right - gap, isle.bbox_bottom - gap,
                    trade_point)
            }
        }

        if gen.enemy_spawners {
            var spawner = instance_create_layer(isle.x, isle.y, "Instances", oEnemySpawner)
            var pos = new Vec2(isle.x, isle.y)
            pos.add_polar(spawner.spawn_distance * 0.8, random(360))
            while collision_point(pos.x, pos.y, oIsland, false, false) {
                pos.set(isle.x, isle.y).add_polar(spawner.spawn_distance * 0.8, random(360))
            }
            spawner.x = pos.x; spawner.y = pos.y
            self.enemy_spawners--
        }

        GenerateItems(isle, gen.trees * oGen.resource_multiplier, oTree)
        GenerateItems(isle, gen.amber * oGen.resource_multiplier, oAmber)
        GenerateItems(isle, gen.big_trees * oGen.resource_multiplier, oBigTree)
        GenerateItems(isle, oGen.amber_tree_generators.get_auto(), oEnemyAmberTree)
    }

    run = function(i, j) {
        self.x0 = oGen.x0 + i * oGen.grid_area_size
        self.y0 = oGen.y0 + j * oGen.grid_area_size
        self.posx_randomer = irandomer(self.x0, self.x0 + oGen.grid_area_size)
        self.posy_randomer = irandomer(self.y0, self.y0 + oGen.grid_area_size)
        var area = oGen.grid[# i, j]
        repeat(self.islands_count) {

            var trade_point = oGen.trade_points_generators.get_auto()
            // if trade_point {
            //     if trade_point == oScroll and array_length(global.locked_abilities_low_tier) == 1 {
            //         if !ArrayEmpty(global.unseen_low_scrolls) {
            //             trade_point = ArrayChoose(global.unseen_low_scrolls)
            //         } else {
	        //             oGen.trade_point_low_conf[0] = 0
	        //             oGen.trade_points_generators.init()
			// 		}
            //     }
            //     if trade_point == oScrollHigh and array_length(global.locked_abilities_high_tier) == 1 {
            //         if !ArrayEmpty(global.unseen_high_scrolls) {
            //             trade_point = ArrayChoose(global.unseen_high_scrolls)
            //         } else {
	        //             oGen.trade_point_high_conf[0] = 0
	        //             oGen.trade_points_generators.init()
			// 		}
            //     }
            // }
            var enemy_flag = oGen.enemy_generators.get_auto()
            var island_gen = oGen.island_generators.get_auto()

            var xx = self.posx_randomer()
            var yy = self.posy_randomer()
            var size_mult = 1 + random(1)
            var resource_factor = (island_gen.trees + island_gen.amber) * 2 * oGen.resource_multiplier
            var size = (1 + resource_factor) * size_mult
            var _sqrt = sqrt(size)
            var spread = max(0, _sqrt - 3)
            var scalex = max(1, round(_sqrt) - irandom_range(-spread, spread))
            var scaley = max(1, round(size / scalex))
            var isle = instance_create_layer(xx, yy, "Bottom", oIsland)
            isle.image_xscale = scalex
            isle.image_yscale = scaley

            self.FixIslandPlacement(isle)
            self.FillIsland(isle, island_gen, trade_point)

            oGen.SpawnEnemiesArea(area)

        }
    }
}

function Area(i, j) constructor {
    self.i = i
    self.j = j
    self.x0 = oGen.x0 + i * oGen.grid_area_size
    self.y0 = oGen.y0 + j * oGen.grid_area_size
    self.x1 = self.x0 + oGen.grid_area_size
    self.y1 = self.y0 + oGen.grid_area_size
    self.generated = false
    self.last_gen_level = 0
    self.is_activated = false
    self.instances = []
}

//// Initialize generators
gen_enemy_spawners = global.gen_enemy_spawners
cell_generators_config = [
    [1, new Cell(5)],
    [3, new Cell(4)],
    [8, new Cell(2)],
    [4, new Cell(1)],
    [2, new Cell(0)],
]
islands_enfir_conf1 = [1, new Island(8, 1)]
islands_enfir_conf2 = [1, new Island(2, 1)]
islands_enfir_conf3 = [2, new Island(0, 1)]
islands_config = [
    [16, new Island(1, 0)],
    [16, new Island(2, 0)],
    [6, new Island(5, 0)],
    [1, new Island(12, 0)],
    [1, new Island(5, 1)],
    islands_enfir_conf1,
    islands_enfir_conf2,
    islands_enfir_conf3,
]
trade_point_low_conf = [1, oScroll]
trade_point_fay_conf = [1, oScrollFay]
trade_point_high_conf = [1, oScrollHigh]
trade_points_config = [
    trade_point_low_conf,
    trade_point_fay_conf,
    [4, oSettlement],
    [3, oWorkshop],
    [20, noone],
]
settlement_generate_chance = 0.2

cell_generators = new RandomerFromConfig(cell_generators_config)
island_generators = new RandomerFromConfig(islands_config)
enemy_generators = new RandomerByProbability(0.3, 20)
trade_points_generators = new RandomerFromConfig(trade_points_config)
harpy_generators = new RandomerByProbability(0, 20)
amber_tree_generators = new RandomerByProbability(0, 20)


island_gen_big_trees = new Island(3, 1, 1, 1)
island_gen_big_trees_conf = [5, island_gen_big_trees]

function RandomerFromConfig(config) constructor {
    self.config = config
    self.list = ds_list_create()
    self.count = 0

    init = function() {
        count = 0
        for (var i = 0; i < array_length(config); ++i) {
            var num = config[i][0]
            var item = config[i][1]
            repeat(num) { ds_list_add(list, item) }
            count += num
        }
        ds_list_shuffle(list)
        return count
    }
    self.init()

    get = function() {
        var value = list[| 0]
        ds_list_delete(list, 0)
        return value
    }

    get_auto = function() {
        if empty() {
            init()
        }
        return get()
    }

    empty = function() {
        return ds_list_empty(list)
    }
}

function RandomerByProbability(probability, total) constructor {
    self.list = ds_list_create()
    self.count = 0
    self.total = total
    self.probability = min(probability, 1)

    init = function() {
        ds_list_set(list, total - 1, false)
        for (var i = 0; i < probability * total; ++i) {
            list[| i] = true
        }
        ds_list_shuffle(list)
    }
    self.init()

    get = function() {
        var value = list[| 0]
        ds_list_delete(list, 0)
        return value
    }

    get_auto = function() {
        if empty() {
            init()
        }
        return get()
    }

    empty = function() {
        return ds_list_empty(list)
    }
}

function Emerge() {
    emerging_level++

    //// Enemy gen chances
    harpy_generators.probability += (emerging_level > 4) * 0.05
    harpy_generators.init()
    amber_tree_generators.probability += (emerging_level > 10) * 0.05
    amber_tree_generators.init()

    switch (emerging_level) {
        case 1: break
        case 4: 
            enemy_spawn.crawlp.area_limit = 10
            enemy_spawn.crawlp.spawns = 3
        break
        case 5:
            trade_point_fay_conf[0] = 2
            islands_enfir_conf1[1].amber++
            islands_enfir_conf2[1].amber++
            islands_enfir_conf3[1].amber++
            array_push(islands_config, island_gen_big_trees_conf)
            island_generators.init()
            break
        case 7:
            enemy_spawn.harpy.spawns = 1
            enemy_spawn.harpy.count_per_spawn = 1
            enemy_spawn.harpy.area_limit = 1
            enemy_spawn.crawlp.area_limit = 15

            islands_enfir_conf1[1].amber++
            islands_enfir_conf2[0]++
            islands_enfir_conf3[0]++
            island_generators.init()
            break
        case 10:
            trade_point_low_conf[0] = 2
            trade_points_generators.init()

            island_gen_big_trees.big_trees = 2
            island_gen_big_trees.trees += 3
            
            enemy_spawn.harpy.area_limit = 2

            enemy_spawn.harpy.count_per_spawn = 2
            enemy_spawn.harpy.area_limit = 4

            islands_enfir_conf1[1].amber++
            islands_enfir_conf2[0]++
            islands_enfir_conf3[0]++
            island_generators.init()
            break
        case 12:
            enemy_spawn.crawlp.count_per_spawn = 4
            enemy_spawn.crawlp.spawns = 3
            enemy_spawn.crawlp.area_limit = 18

            islands_enfir_conf1[1].amber++
            islands_enfir_conf2[0]++
            islands_enfir_conf3[0]++
            island_generators.init()
        case 13:
            island_gen_big_trees.big_trees = 3
            island_gen_big_trees.trees += 3

            enemy_spawn.harpy.spawns = 2
            enemy_spawn.harpy.area_limit = 8
            enemy_spawn.harpy.count_per_spawn = 3

            enemy_spawn.crawlp.count_per_spawn = 4
            enemy_spawn.crawlp.spawns = 4
            enemy_spawn.crawlp.area_limit = 25
            break
        case 14:
            island_gen_big_trees.big_trees = 4
            island_gen_big_trees.trees += 3
            enemy_spawn.harpy.area_limit = 6
            enemy_spawn.crawlp.area_limit = 20
        break
        case 15:
            SpawnBoss()
        break
    }
    if emerging_level > 4 {
        resource_multiplier += emerge_resource_gain
    }

    if emerging_level == 15 {
        array_push(trade_points_config, trade_point_high_conf)
        trade_points_generators.init()
    }
}

function SpawnEnemiesArea(area) {
    var harpies_count = 0
    var crawlps_count = 0
    var size = enemy_spawn_sub_area_size
    var is_crawp_spawner = false
    var xspawn = irandomer(area.x0, area.x1 - size)
    var yspawn = irandomer(area.y0, area.y1 - size)
    while (area.last_gen_level < emerging_level) {
        area.last_gen_level++
        harpies_count = oGen.RectAreaCount(area, oEnemyHarpy)
        crawlps_count = oGen.RectAreaCount(area, oEnemyCrawlp)
        if harpies_count < enemy_spawn.harpy.area_limit {
            var xx = xspawn()
            var yy = yspawn()
            RandomSpawnRect(xx, yy, xx + size, yy + size,
                            enemy_spawn.harpy.count_per_spawn, oEnemyHarpy)
        }
        if crawlps_count < enemy_spawn.crawlp.area_limit {
            if !is_crawp_spawner {
                is_crawp_spawner = true
                var xx = xspawn()
                var yy = yspawn()
                RandomSpawnRect(xx, yy, xx + size, yy + size,
                                enemy_spawn.crawlp.count_per_spawn, oEnemyCrawlp, oIsland)
            } else {
                is_crawp_spawner = false
                RandomSpawnRect(
                    area.x0, area.y0,
                    area.x1, area.y1,
                    1, oEnemySpawner)
            }
        }
    }
}

function SpawnEnemies() {
    var vec_check = new Vec2(ship_grid_pos.x, ship_grid_pos.y)
    for (var i = -1; i < 2; i++) {
        for (var j = -1; j < 2; j++) {
            vec_check.set(ship_grid_pos.x + i, ship_grid_pos.y + j)
            // if GridCheck(vec_check) {
                SpawnEnemiesArea(grid[# vec_check.x, vec_check.y])
            // }
        }
    }
}

function GenerateArea(i, j) {
    var area = grid[# i, j]
    if (!area.generated) {
        array_push(generated_areas, area)
        area.generated = true
        oGen.cell_generators.get_auto().run(i, j)
    }

}

function UpdateShipGridPos() {
    ship_grid_pos_prev.set(ship_grid_pos.x, ship_grid_pos.y)
    ship_grid_pos.set((oShip.x - x0) div grid_area_size,
                      (oShip.y - y0) div grid_area_size)
}

function GridGet(vec) {
    return grid[# vec.x, vec.y]
}

function w2gx(xx) {
    return (xx - x0) div grid_area_size
}

function w2gy(yy) {
    return (yy - y0) div grid_area_size
}

function GridGetByCoords(xx, yy) {
    static ___grid_get_vec = new Vec2(0, 0)
    ___grid_get_vec.set(w2gx(xx), w2gy(yy))
    // if GridCheck(___grid_get_vec) {
        return GridGet(___grid_get_vec)
    // }
    return undefined
}

function GridCheck(vec) {
    return !(vec.x < 0 || vec.x >= grid_w || vec.y < 0 || vec.y >= grid_h)
}

function RectAreaCount(area, obj) {
    return RectInstanceCount(area.x0, area.y0, area.x1, area.y1, obj)
}

function SpawnBoss() {
    var pos = oShip.position.add_polar_(1000, random(360))
    instance_create_layer(pos.x, pos.y, "Instances", oEnemyAmberTitan)
    oMusic.BossPhase()
    oCamera.boss_timer.reset()
}

ship_grid_pos.set(w2gx(oShip.x), w2gy(oShip.y))
