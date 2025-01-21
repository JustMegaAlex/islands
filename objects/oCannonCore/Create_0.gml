
grav = 0.2
sp = 15
vz = 0
velocity = new Vec2(0, 0)
zmax = 300
distance = 0
distance_passed = 0

function Launch(xx, yy) {
    velocity.set_polar(sp, PointDir(xx, yy))

    z = oShip.z
	var z0_reduced = abs(z/zmax)
	var d0_reduced = -(sqrt(1-z0_reduced)/2) + 0.5
	distance = PointDist(xx, yy) / (1 - d0_reduced)
	distance_passed = d0_reduced * distance
}
