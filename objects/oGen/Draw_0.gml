// Get camera view boundaries
// var _cam_x = camera_get_view_x(view_camera[0]) - x0
// var _cam_y = camera_get_view_y(view_camera[0]) - y0
// var _cam_w = camera_get_view_width(view_camera[0])
// var _cam_h = camera_get_view_height(view_camera[0])

// // Calculate grid cells that are visible in camera view
// var _start_col = max(0, floor(_cam_x / grid_area_size))
// var _start_row = max(0, floor(_cam_y / grid_area_size))
// var _end_col = min(grid_w - 1, ceil((_cam_x + _cam_w) / grid_area_size))
// var _end_row = min(grid_h - 1, ceil((_cam_y + _cam_h) / grid_area_size))

// _debug_corner_cells = [
//     _start_col,
//     _start_row,
//     _end_col,
//     _end_row,
// ]

// // Draw visible grid cells
// for (var _col = _start_col; _col <= _end_col; _col++) {
//     for (var _row = _start_row; _row <= _end_row; _row++) {
//         var _x1 = _col * grid_area_size + x0
//         var _y1 = _row * grid_area_size + y0
        
//         // Draw cell rectangle
//         var col = (_col == ship_grid_pos.x) and (_row == ship_grid_pos.y) ? c_green : c_white
//         draw_set_color(col)
//         draw_rectangle(_x1, _y1, _x1 + grid_area_size, _y1 + grid_area_size, true)
//         draw_set_color(c_white)
//     }
// }

