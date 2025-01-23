
if sprite_index == sWhitePixel {
    image_xscale = default_rect.x
    image_yscale = default_rect.y
    image_blend = default_color
	if !is_flying {
        AttachToIsland()	
	}
    island_collision_paddingx = sprite_width * 0.5
}

hp = hp_max
