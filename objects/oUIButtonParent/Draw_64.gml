

var img = min(mouse_over + active * 2, 2)
if !command.available() {
    img = 3
}

draw_sprite_ext(
    sprite_index, img,
    x, y, image_xscale, image_yscale,
    image_angle, image_blend, image_alpha)

if icon_sprite != noone {
    draw_sprite(icon_sprite, 0, x, y)
}
