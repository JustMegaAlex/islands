

if amber_wrath_timer.timer > 0 {
    frame++
    draw_sprite_ext(sAmberWrath, frame, x, y + z, image_xscale, 1, 0, c_white, 1)
}

event_inherited()

