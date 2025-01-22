

draw_sprite(sprite_index, active or mouse_over, x, y)
draw_text(x, y - 100, $"{x}, {y}")

if icon_sprite != noone {
    draw_sprite(icon_sprite, 0, x, y)
}
