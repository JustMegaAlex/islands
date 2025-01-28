
image_blend = c_yellow
sp = 30
spx = 10
spz = 0
z = 0
z_start = 0
dist_left = 0

cos_ = 0

shadow_size = sprite_width

function Launch(z_, angle) {
    z = z_
    var cos_ = lengthdir_x(1, angle)
    var sin_ = lengthdir_y(1, angle)
    x += z * cos_ / sin_

    spx = sp * cos_
    spz = sp * sin_
    dist_left = abs(z / sin_)
}

function Boom() {
    instance_destroy()
}
