
//// Dynamic grid gen
UpdateShipGridPos()

var vec_check = new Vec2(ship_grid_pos.x, ship_grid_pos.y)
if !(ship_grid_pos.eq(ship_grid_pos_prev)) {
    for (var i = -1; i < 2; i++) {
        for (var j = -1; j < 2; j++) {
            vec_check.set(ship_grid_pos.x + i, ship_grid_pos.y + j)
            if GridCheck(vec_check) and !GridGet(vec_check).generated {
                GenerateArea(ship_grid_pos.x + i, ship_grid_pos.y + j)
                show_debug_message($"Generated area at {ship_grid_pos.x + i}, {ship_grid_pos.y + j}")
            }
        }
    }
}


//// Amber emerging
if !emerge_timer.update() {
    Emerge()
    emerge_timer.reset()
}
