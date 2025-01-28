
var scale = shadow_size / sprite_get_width(sShadow)
draw_sprite_ext(
    sShadow, 0, x, y, 
    scale, scale * 0.33, 0, c_white, 0.3)

draw_sprite_ext(
    sprite_index, image_index,
    x, y + z,
    image_xscale, image_yscale,
	image_angle, image_blend, image_alpha)
