
var scale = shadow_size / sprite_get_width(sShadow)
draw_sprite_ext(
    sShadow, 0, x, y, 
    scale, scale * 0.33, 0, c_white, 0.3)

draw_sprite_ext(
    sprite_index, image_index,
    x, y + z,
    image_xscale, image_yscale,
	image_angle, image_blend, image_alpha)


// var atk = attack_target_move ?? attack_target
// if atk {
// 	draw_circle(atk.x, atk.y, 10, false)
// }

if marked_for_pickup {
    draw_sprite(sUIGrabIndicator, 0, x, y - 30)
}

if marked_for_mining {
    draw_sprite(sUIMineIndicator, 0, x, y - 30)
}

if is_structure and build_timer.timer {
    draw_text(x, y, int64(build_timer.timer / 60))
}

if hp < hp_max {
    draw_set_color(c_red)
    draw_line_width(x - 30, y - 40, x + 30, y - 40, 2)
    draw_set_color(c_aqua)
    var len = (hp / hp_max) * 60
    draw_line_width(x - 30, y - 40, x - 30 + len, y - 40, 2)
    draw_set_color(c_white)
}

if attackers_count != 0 {
    draw_text(x, y - 100, attackers_count)
}
