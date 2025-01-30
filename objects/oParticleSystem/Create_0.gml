
system = part_system_create()

function SpriteEffect(xx, yy, sprite) {
    return instance_create_layer(xx, yy, "Instances", oParticle, {sprite_index: sprite})
}

function WaterSplash(xx, yy) {
	//part_particles_burst(system, xx, yy, psWaterSplash)
}
