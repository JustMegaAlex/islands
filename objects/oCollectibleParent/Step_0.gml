
CHECK_PAUSE


if !is_collected {
    exit
}

var dist = FlyingInstDist(oShip)

if dist <= sp_max {
    OnCollect()
	audio_play_sound(
		choose(sfxCollect1, sfxCollect2, sfxCollect3, sfxCollect4),
		0, false)
    instance_destroy()
    exit
}

velocity.set_polar(sp_max * min(1, 100/max(dist, 1)), FlyingInstDir(oShip))

x += velocity.x
y += velocity.y
