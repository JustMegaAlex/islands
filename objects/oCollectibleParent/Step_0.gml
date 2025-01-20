
if !is_collected {
    exit
}

var dist = FlyingInstDist(oShip)

if dist <= sp_max {
    OnCollect()
    instance_destroy()
    exit
}

velocity.set_polar(sp_max * min(1, 100/max(dist, 1)), FlyingInstDir(oShip))

x += velocity.x
y += velocity.y
