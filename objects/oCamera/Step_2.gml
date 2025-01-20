
//// Mouse input
var gap = CamW() * 0.01
var inpx = 0
var inpy = 0
if use_mouse_scroll {
    inpx = (mouse_x > (CamX() + CamW() - gap)) - (mouse_x < (CamX() + gap))
    inpy = (mouse_y > (CamY() + CamH() - gap)) - (mouse_y < (CamY() + gap))
}

//// Keyboard input
if inpx == 0 and inpy == 0 {
    inpx = oInput.right - oInput.left
    inpy = oInput.down - oInput.up
}

x += (inpx) * spd * zoom
y += (inpy) * spd * zoom


ChangeZoom(oInput.scroll_down - oInput.scroll_up)
zoom_prev = zoom
zoom = Approach2(zoom, zoom_to, 0.04, 0.01)
//// Zoom with ancor in center of the screen
if zoom_prev != zoom {
    var xx = CamXCent()
    var yy = CamYCent()
    SetZoom(zoom)
    CameraSetPos(xx, yy)
}

// update camera position with clampint to room bounds
CameraSetCentPos(x, y)


//// Mouse drag
if mouse_check_button_pressed(drag_button) {
    drag_xst = mouse_x
    drag_yst = mouse_y
}

if mouse_check_button(drag_button)
        and ((mouse_x_prev != mouse_x)
             or (mouse_y_prev != mouse_y)) {
    x += mouse_x_prev - mouse_x
    y += mouse_y_prev - mouse_y
} else {
	mouse_x_prev = mouse_x
	mouse_y_prev = mouse_y
}


