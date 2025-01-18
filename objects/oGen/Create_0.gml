

grid_w = 1000
grid_h = 1000

grid_area_size = 4000
x0 = oShip.x - grid_w * grid_area_size / 2
y0 = oShip.y - grid_h * grid_area_size / 2

grid = ds_grid_create(grid_w, grid_h)
ship_grid_pos_prev = new Vec2(-infinity, -infinity)
ship_grid_pos = new Vec2(0, 0)
for (var i = 0; i < grid_w; i++) {
    for (var j = 0; j < grid_h; j++) {
        grid[# i, j] = new Area()
    }
}

//// Initialize generators
generators = ds_list_create()
generators_config = {
    n10: new Generator(5),
    n5: new Generator(1),
    n20: new Generator(2),
    n9: new Generator(3),
}

function Generator(islands_count=4, trees_prosperity=2, amber_prosperity=2) constructor {
    self.islands_count = islands_count
    self.size_randomer = irandomer(400, 1000)
    self.trees_randomer = irandomer(trees_prosperity, trees_prosperity * 1.5)
    self.amber_randomer = irandomer(amber_prosperity, amber_prosperity * 1.5)

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
                    if !ent or !ent.is_resource {
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

    FillIsland = function(isle) {
        GenerateItems(isle, trees_randomer(), oTree)
        GenerateItems(isle, amber_randomer(), oAmber)
    }

    run = function(i, j) {
        self.x0 = oGen.x0 + i * oGen.grid_area_size
        self.y0 = oGen.y0 + j * oGen.grid_area_size
        self.posx_randomer = irandomer(self.x0, self.x0 + oGen.grid_area_size)
        self.posy_randomer = irandomer(self.y0, self.y0 + oGen.grid_area_size)
        repeat(self.islands_count) {
            var xx = self.posx_randomer()
            var yy = self.posy_randomer()
            var size = self.size_randomer()
            var isle = instance_create_layer(xx, yy, "Bottom", oIsland)
            isle.image_xscale = size / sprite_get_width(isle.sprite_index)
            isle.image_yscale = size / sprite_get_height(isle.sprite_index)

            self.FixIslandPlacement(isle)
            self.FillIsland(isle)
        }
    }
}

function Area() constructor {
    generated = false
}


function InitGenerators() {
    var keys = variable_struct_get_names(generators_config)
    for (var i = 0; i < array_length(keys); ++i) {
        var key = keys[i]
        var num = real(string_copy(key, 2, 2))
        var gen = generators_config[$ key]
        repeat(num) { ds_list_add(generators, gen) }
    }
    ds_list_shuffle(generators)
}

function GenerateArea(i, j) {
    var area = grid[# i, j]
    if (area.generated) { return }
    area.generated = true
    generators[| 0].run(i, j)
    ds_list_delete(generators, 0)
    if ds_list_empty(generators) {
        show_debug_message("Generators are empty, reinitializing")
        InitGenerators()
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

show_debug_message($"ship_grid_pos: {ship_grid_pos.x}, {ship_grid_pos.y}, ship_grid_pos_prev: {ship_grid_pos_prev.x}, {ship_grid_pos_prev.y}")

InitGenerators()
