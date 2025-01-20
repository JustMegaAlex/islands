
distance_passed += sp
var xx = distance_passed / distance

z = -zmax * (1 - sqr(xx - 0.5) * 4)

x += velocity.x
y += velocity.y

if distance_passed >= distance {
    instance_destroy()
}
