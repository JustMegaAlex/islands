

// DebugDrawVar("fps", fps_real)
// DebugDrawVar("mouse", $"{mouse_x}, {mouse_y}")

if global.playground_mode {
    draw_set_halign(fa_center)
    draw_set_font(fntDefault)
    draw_set_color(c_white)
    draw_text(window_get_width() / 2, window_get_height() / 2 - 300, 
        "Playground mode. Take your time to learn controls.\nYou can start with hints in the bottom left corner.")
}
