
x += lengthdir_x(sp, image_angle)
y += lengthdir_y(sp, image_angle)

dist -= sp

if dist <= 0 {
    instance_destroy()
    if instance_exists(target) {
        target.Hit(id)
    }
}
