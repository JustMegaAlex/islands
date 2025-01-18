

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

function Generator(i, j, islands_count=4) constructor {
    self.x0 = other.x0 + i * other.grid_area_size
    self.y0 = other.y0 + j * other.grid_area_size
    self.islands_count = islands_count
    self.posx_randomer = irandomer(self.x0, self.x0 + other.grid_area_size)
    self.posy_randomer = irandomer(self.y0, self.y0 + other.grid_area_size)
    self.size_randomer = irandomer(400, 1000)

    run = function() {
        repeat(self.islands_count) {
            var xx = self.posx_randomer()
            var yy = self.posy_randomer()
            var size = self.size_randomer()
            var isle = instance_create_layer(xx, yy, "Instances", oIsland)
            isle.image_xscale = size / sprite_get_width(isle.sprite_index)
            isle.image_yscale = size / sprite_get_height(isle.sprite_index)
            var cycles = 1000
            with isle {
                while place_meeting(xx, yy, oIsland) {
                    xx = other.posx_randomer()
                    yy = other.posy_randomer()
                    cycles--
                    if (cycles <= 0) {
                        show_error($"Failed to place island at {xx}, {yy}", false)
                        break
                    }
                    // show_debug_message($"Placed island at {xx}, {yy}")
                }
            }
        }
    }
}

function Area() constructor {
    generated = false
}

function GenerateArea(i, j) {
    var area = grid[# i, j]
    show_debug_message($"{i} {j} area.generated: {area.generated}")
    if (area.generated) { return }
    area.generated = true
    show_debug_message($"{i} {j} area.generated: {area.generated}")
    new Generator(i, j).run()
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
