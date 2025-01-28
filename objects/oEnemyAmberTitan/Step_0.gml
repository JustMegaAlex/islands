
event_inherited()

var dist = InstDist(oShip)
if !harpies_swarm.timer.update() && dist < harpies_swarm.trigger_distance {
    HarpiesSwarm()
    harpies_swarm.timer.reset()
}
