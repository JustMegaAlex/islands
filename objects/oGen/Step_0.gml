
UpdateShipGridPos()

// if !(ship_grid_pos.eq(ship_grid_pos_prev)) {
//     show_debug_message("Grid pos changed")
//     if GridCheck(ship_grid_pos) {
//         show_debug_message("Grid pos is valid")
//         if !GridGet(ship_grid_pos).generated {
//             show_debug_message("Grid pos is not generated")
//         }
//     }
// }

if !(ship_grid_pos.eq(ship_grid_pos_prev))
        and GridCheck(ship_grid_pos)
        and !GridGet(ship_grid_pos).generated {
    GenerateArea(ship_grid_pos.x, ship_grid_pos.y)
    show_debug_message($"Generated area at {ship_grid_pos.x}, {ship_grid_pos.y}")
}
