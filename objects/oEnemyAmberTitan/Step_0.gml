
event_inherited()

var dist = InstDist(oShip)
if !harpies_swarm.timer.update() && dist < harpies_swarm.trigger_distance {
    HarpiesSwarm()
    harpies_swarm.timer.reset()
}

amber_rain.target = oShip

if !amber_rain.timer.update() and amber_rain.target {
    amber_rain.number_to_spawn = amber_rain.number
    amber_rain.timer.reset()
}

if amber_rain.number_to_spawn and !amber_rain.spawn_timer.update() {
    AmberRain()
    amber_rain.number_to_spawn--
    amber_rain.spawn_timer.reset()
}
