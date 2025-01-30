
event_inherited()

if !seen_by_player {
    frames++
    draw_sprite_ext(sprite_index, 1, x, y, 
                    image_xscale, image_yscale, 0, image_blend, 
                    0.5 + lengthdir_x(0.5, frames * 12))
}
