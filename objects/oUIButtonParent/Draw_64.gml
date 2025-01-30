

var img = min(mouse_over + command.active * 2, 2)
if !command.available() {
    img = 3
}

draw_sprite_ext(
    sprite_index, img,
    x, y, image_xscale, image_yscale,
    image_angle, image_blend, image_alpha)

if icon_sprite != noone {
    draw_sprite(icon_sprite, 0, x, y)
} else {
	draw_set_font(fntSmall)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	draw_set_color(c_white)
	draw_text(x, y, name)
}