
var scale = shadow_size / sprite_get_width(sShadow)
draw_sprite_ext(
    sShadow, 0, x, y, 
    scale, scale * 0.33, 0, c_white, 0.3)

draw_sprite_ext(
    sprite_index, image_index,
    x, y + z,
    image_xscale, image_yscale,
	image_angle, image_blend, image_alpha)


draw_circle(x, y, 150, true)

var atk = attack_target_move ?? attack_target
if atk {
	draw_circle(atk.x, atk.y, 10, false)
}

if marked_for_pickup {
    draw_sprite(sUIDefault, 0, x, y - 30)
}

if marked_for_mining {
    draw_sprite(sUIDefault, 0, x, y - 30)
}

if is_structure and build_timer.timer {
    draw_text(x, y, int64(build_timer.timer / 60))
}