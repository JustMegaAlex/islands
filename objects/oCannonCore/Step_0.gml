
CHECK_PAUSE

distance_passed += sp
var xx = distance_passed / distance

var h = (1 - sqr(xx - 0.5) * 4)
z = -zmax * h

x += velocity.x
y += velocity.y

if distance_passed >= distance {
	oParticles.WaterSplash(x, y)
    var list = ds_list_create()
    EntitiesListCircle(x, y, damage_radius, list)
    for (var i = 0; i < ds_list_size(list); ++i) {
        var inst = list[| i]
        inst.Hit(id)
    }
	PlaySoundAt(x, y, sfxCannonExplosion)
    instance_destroy()
}
