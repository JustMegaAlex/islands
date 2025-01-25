
surface_resize(surf, CamW(), CamH())

surface_set_target(surf)
draw_clear(c_black)

if point_in_rectangle(
        oShip.x, oShip.y, 
        CamX() - vision_range * 1.2,
        CamY() - vision_range * 1.2,
        CamX() + CamW() + vision_range * 1.2,
        CamY() + CamH() + vision_range * 1.2) {
    var xx = oShip.x - CamX()
    var yy = oShip.y - CamY()
    gpu_set_blendmode(bm_subtract)
    draw_circle(xx, yy, vision_range, false)
    draw_set_alpha(0.5)
    draw_circle(xx, yy, vision_range * 1.25, false)
    draw_set_alpha(1)
    gpu_set_blendmode(bm_normal)
}

surface_reset_target()
draw_surface(surf, CamX(), CamY())
