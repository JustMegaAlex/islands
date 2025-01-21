
system = part_system_create()

function WaterSplash(xx, yy) {
	part_particles_burst(system, xx, yy, psWaterSplash)
}
