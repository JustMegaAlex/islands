
if sprite_index == sWhitePixel {
    if !is_hidden {
        image_xscale = default_rect.x
        image_yscale = default_rect.y
    }
    image_blend = default_color
	if !is_flying {
        AttachToIsland()	
	}
}
