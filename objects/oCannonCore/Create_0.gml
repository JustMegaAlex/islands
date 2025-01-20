
grav = 0.2
sp = 10
vz = 0
velocity = new Vec2(0, 0)
zmax = 300
distance = 0
distance_passed = 0

function Launch(xx, yy) {
    z = oShip.z
	distance_passed = ((sqrt(1-z/zmax)/2) + 0.5) * zmax
    velocity.set_polar(sp, PointDir(xx, yy))
    distance = distance_passed + PointDist(xx, yy)
}
