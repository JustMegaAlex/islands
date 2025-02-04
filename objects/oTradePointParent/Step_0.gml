
var close = InstDist(oShip) < 200
if !instance_exists(button) and close {
    InstanceActivate(button, id)
} else if instance_exists(button) and !close {
    InstanceDeactivate(button, id)
}
