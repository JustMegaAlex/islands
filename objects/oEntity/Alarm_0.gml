
if sprite_index == sWhitePixel {
    image_xscale = default_rect.x
    image_yscale = default_rect.y
    image_blend = default_color
    island_collision_paddingx = sprite_width * 0.5
}

if !is_flying {
    AttachToIsland()	
}

image_xscale_start = image_xscale

if is_structure {
    image_alpha = 0.5
}

hp = hp_max
