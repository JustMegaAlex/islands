
draw_self()

if instance_exists(oShip) {
	draw_sprite_ext(sShipHealthBar1, 0, x, y, image_xscale * oShip.hp / oShip.hp_max, 1, 0, c_white, 1)
}
