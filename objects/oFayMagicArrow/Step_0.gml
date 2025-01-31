
if !instance_exists(target) {
    instance_destroy()
    exit
}

x += lengthdir_x(sp, image_angle)
y += lengthdir_y(sp, image_angle)

var diff = angle_difference(image_angle, InstDir(target))
image_angle = Approach(image_angle, image_angle - diff, rot_speed)
rot_speed += 0.4

if InstDist(target) < sp {
    if instance_exists(target) {
        target.Hit(id)
    }
    instance_destroy()
	PlaySoundAt(x, y, sfxArrowHit)
}
