
EnsureSingleton()

velocity = new Vec2(0, 0)

view_enabled = true
view_visible[0] = true

aspect_ratio = 1920 / 1080
camera_width = 1920
camera_height = camera_width / aspect_ratio

zoom = 1
zoom_to = 1
zoom_treshold_speed = 40
zoom_factor = 0.25
zoom_max = 3
zoom_min = 1

// mouse drag
drag_button = mb_middle
mouse_x_prev = 0
mouse_y_prev = 0

use_mouse_scroll = false

spd = 25

function ChangeZoom(step) {
    zoom_to += step * zoom_factor
    if global.camera_clamp_zoom {
        zoom_to = clamp(zoom_to, zoom_min, zoom_max)
    }
}

function SetZoom(value) {
    zoom = value
    camera_set_view_size(view_camera[0], camera_width * zoom, camera_height * zoom)
}

if instance_exists(oShip) {
    x = oShip.x
    y = oShip.y
}

boss_timer = MakeTimer(120, 0)




