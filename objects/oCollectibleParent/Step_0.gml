
if !is_collected {
    exit
}

velocity.set_polar(sp, InstDir(oShip))

x += velocity.x
y += velocity.y

if InstDist(oShip) <= sp {
    OnCollect()
    instance_destroy()
}
