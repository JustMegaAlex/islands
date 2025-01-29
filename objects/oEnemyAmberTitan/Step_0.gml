
event_inherited()

if hp <= 0 {
    exit
}

var dist = InstDist(oShip)
if !harpies_swarm.timer.update() && dist < harpies_swarm.trigger_distance {
    HarpiesSwarm()
    harpies_swarm.timer.reset()
}

if !amber_rain.target or !instance_exists(amber_rain.target) {
    amber_rain.target = FindAmberRainTarget()
}
if !amber_rain.timer.update() and amber_rain.target {
    amber_rain.number_to_spawn = amber_rain.number
    amber_rain.timer.reset()
}

if amber_rain.number_to_spawn and !amber_rain.spawn_timer.update() {
    AmberRain()
    amber_rain.number_to_spawn--
    amber_rain.spawn_timer.reset()
}
