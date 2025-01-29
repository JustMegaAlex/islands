
if !enabled {
    exit
}

if !surface_exists(surf) {
    surf = surface_create(surf_w, surf_h)
}

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
    var ratio = surf_w / CamW()
    gpu_set_blendmode(bm_subtract)
    draw_circle(xx * ratio, yy * ratio, vision_range * ratio * 0.8, false)
    draw_set_alpha(0.5)
    draw_circle(xx * ratio, yy * ratio, vision_range * ratio, false)
    draw_set_alpha(1)
    gpu_set_blendmode(bm_normal)
}

surface_reset_target()
draw_surface_stretched(surf, CamX(), CamY(), CamW(), CamH())
