
surface_resize(surf, CamW(), CamH())

surface_set_target(surf)
draw_clear_alpha(c_black, 0.5)

if CollisionCamera(oShip, false, false) {
    gpu_set_blendmode(bm_subtract)
    draw_circle(0, 0, vision_range, false)
    draw_set_alpha(0.7)
    draw_circle(0, 0, vision_range * 1.25, false)
    draw_set_alpha(1)
    gpu_set_blendmode(bm_normal)
}

surface_reset_target()
draw_surface(surf, CamX(), CamY())
