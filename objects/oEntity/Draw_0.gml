
if sprite_index == -1 {
    draw_set_color(default_color)
    draw_rectangle(
        x - default_rect.x / 2, y - default_rect.y / 2,
        x + default_rect.x / 2, y + default_rect.y / 2,
        false)
    draw_set_color(c_white)
    exit
}

draw_sprite_ext(
    sprite_index, image_index,
    x, y + z,
    image_xscale, image_yscale,
	image_angle, image_blend, image_alpha)

var scale = shadow_size / sprite_get_width(sShadow)
draw_sprite_ext(
    sShadow, 0, x, y, 
    scale, scale * 0.33, 0, c_white, 0.3)
