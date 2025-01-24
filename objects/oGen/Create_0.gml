
_debug_corner_cells = []


grid_w = 100
grid_h = 100

grid_area_size = 3000
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
emerge_timer = MakeTimer(global.gen_emerge_secs * sec)
emerge_spawn_crawlps = 0
enemy_spawners_max_per_cell = 2

//// Initialize generators
gen_enemy_spawners = global.gen_enemy_spawners
cell_generators = ds_list_create()
island_generators = ds_list_create()
enemy_generators = ds_list_create()
settlement_generators = ds_list_create()
cell_generators_config = {
    n1: new Cell(5),
    n3: new Cell(4),
    n8: new Cell(2),
    n4: new Cell(1),
    n2: new Cell(0),
}
islands_config = {
    n5: new Island(0, 1),
    n5: new Island(1, 0),
    n8: new Island(2, 1),
    n3: new Island(5, 1),
    n1: new Island(8, 1),
    n1: new Island(12, 0),
    n1: new Island(2, 4),
}
enemy_generate_chance = 0.3
settlement_generate_chance = 0.2
cells_config_count = 0
islands_config_count = 0

function Island(trees, amber, enemy_spawners=0) constructor {
    self.trees = irandom_range(trees, trees * 1.5)
    self.amber = irandom_range(amber, amber * 1.5)
    self.enemy_spawners = enemy_spawners
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
                // show_debug_message($"Placed island at {xx}, {yy}")
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

    FillIsland = function(isle, gen, add_settlement=false) {
        if add_settlement {
            GenerateItems(isle, 1, oSettlement)
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

        GenerateItems(isle, gen.trees, oTree)
        GenerateItems(isle, gen.amber, oAmber)
    }

    run = function(i, j) {
        self.x0 = oGen.x0 + i * oGen.grid_area_size
        self.y0 = oGen.y0 + j * oGen.grid_area_size
        self.posx_randomer = irandomer(self.x0, self.x0 + oGen.grid_area_size)
        self.posy_randomer = irandomer(self.y0, self.y0 + oGen.grid_area_size)
        var area = oGen.grid[# i, j]
        repeat(self.islands_count) {

            var add_settlement = oGen.settlement_generators[| 0]
            ds_list_delete(oGen.settlement_generators, 0)
            if ds_list_empty(oGen.settlement_generators) with oGen {
                FillListByProbability(settlement_generators, settlement_generate_chance, 20)
            }
            var enemy_flag = oGen.enemy_generators[| 0]
            ds_list_delete(oGen.enemy_generators, 0)
            if ds_list_empty(oGen.enemy_generators) with oGen {
                FillListByProbability(enemy_generators, enemy_generate_chance, 20)
            }

            var island_gen = oGen.island_generators[| 0]
            ds_list_delete(oGen.island_generators, 0)
            if ds_list_empty(oGen.island_generators) with oGen {
                FillListFromConfig(island_generators, islands_config)
            }

            var xx = self.posx_randomer()
            var yy = self.posy_randomer()
            var size_mult = 1 + random(1)
            var size = (1 + (island_gen.trees + island_gen.amber) * 2) * size_mult
            var _sqrt = sqrt(size)
            var spread = max(0, _sqrt - 3)
            var scalex = max(1, round(_sqrt) - irandom_range(-spread, spread))
            var scaley = max(1, round(size / scalex))
            var isle = instance_create_layer(xx, yy, "Bottom", oIsland)
            isle.image_xscale = scalex
            isle.image_yscale = scaley

            if scalex == 1 and scaley > 2 {
                var test = true
            }

            self.FixIslandPlacement(isle)
            self.FillIsland(isle, island_gen, add_settlement)

            if oGen.RectAreaCount(area, oEnemySpawner) < oGen.enemy_spawners_max_per_cell {
                RandomSpawnRect(
                    area.x0, area.y0,
                    area.x1, area.y1,
                    oGen.emerge_spawn_crawlps + enemy_flag * oGen.gen_enemy_spawners,
                    oEnemySpawner, oIsland)
            }

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
    self.just_generated = true
}

function FillListFromConfig(list, config) {
    var keys = variable_struct_get_names(config)
    var count = 0
    for (var i = 0; i < array_length(keys); ++i) {
        var key = keys[i]
        var num = real(string_copy(key, 2, 4))
        var item = config[$ key]
        repeat(num) { ds_list_add(list, item) }
        count += num
    }
    ds_list_shuffle(list)
    return count
}

function FillListByProbability(list, probability, total) {
    ds_list_set(list, total - 1, false)
    for (var i = 0; i < probability * total; ++i) {
        list[| i] = true
    }
    ds_list_shuffle(list)
}

function InitAllGenerators() {
    cells_config_count = FillListFromConfig(cell_generators, cell_generators_config)
    islands_config_count = FillListFromConfig(island_generators, islands_config)
    if ds_list_empty(enemy_generators) {    
        FillListByProbability(enemy_generators, enemy_generate_chance, 20)
    }
    if ds_list_empty(settlement_generators) {
        FillListByProbability(settlement_generators, settlement_generate_chance, 20)
    }
}

function Emerge() {
    emerging_level++
    if (emerging_level mod 5) == 0 {
        enemy_generate_chance += 0.1
        emerge_spawn_crawlps += 1
        enemy_spawners_max_per_cell += 1
    }
    repeat emerging_level div 5 {
        SpawnCrawlps()
    }
    switch (emerging_level) {
        case 1: break
    }
}

function SpawnCrawlps() {
    for (var i = 0; i < array_length(generated_areas); ++i) {
        var area = generated_areas[i]
        if area.just_generated {
            area.just_generated = false
            continue
        }
        if oGen.RectAreaCount(area, oEnemySpawner) < oGen.enemy_spawners_max_per_cell {
            RandomSpawnRect(
                area.x0, area.y0,
                area.x1, area.y1,
                emerge_spawn_crawlps, oEnemySpawner, oIsland)
        }
    }
}

function GenerateArea(i, j) {
    var area = grid[# i, j]
    if (area.generated) { return }
    array_push(generated_areas, area)
    area.generated = true
    oGen.cell_generators[| 0].run(i, j)
    ds_list_delete(cell_generators, 0)
    if ds_list_empty(cell_generators) {
        show_debug_message("Generators are empty, reinitializing")
        FillListFromConfig(cell_generators, cell_generators_config)
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

function GridCheck(vec) {
    return !(vec.x < 0 || vec.x >= grid_w || vec.y < 0 || vec.y >= grid_h)
}

function RectAreaCount(area, obj) {
    return RectInstanceCount(area.x0, area.y0, area.x1, area.y1, obj)
}

show_debug_message($"ship_grid_pos: {ship_grid_pos.x}, {ship_grid_pos.y}, ship_grid_pos_prev: {ship_grid_pos_prev.x}, {ship_grid_pos_prev.y}")

InitAllGenerators()
var test = true