function CameraSetPos(x, y) {
    var cam = view_camera[0];
    camera_set_view_pos(cam,
                        x - camera_get_view_width(cam) * 0.5,
                        y - camera_get_view_height(cam) * 0.5);
}

function CamW() {
    return camera_get_view_width(view_camera[0]);
}

function CamH() {
    return camera_get_view_height(view_camera[0]);
}

function CamX() {
    return camera_get_view_x(view_camera[0]);
}

function CamY() {
    return camera_get_view_y(view_camera[0]);
}

function CamXCent() {
    return camera_get_view_x(view_camera[0]) + CamW() * 0.5;
}

function CamYCent() {
    return camera_get_view_y(view_camera[0]) + CamH() * 0.5;
}

function CamLeft() {
	return CamX() + CamW()
}

function CamBottom() {
	return CamY() + CamH()
}

function PointInCamera(xx, yy) {
    var cx = CamX(), cy = CamY();
    return (xx > cx) && (xx < (cx + CamW())) && (yy > cy) && (yy < (cy + CamH()));
}

function CollisionCamera(obj, precise=false, notme=false) {
	return collision_rectangle(CamX(), CamY(), CamLeft(), CamBottom(), obj, precise, notme)
}




