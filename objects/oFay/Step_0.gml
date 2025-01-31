
UPDATE_DEPTH

if !reload_timer.update() {
    var arr = EntitiesInCircle(x, y - z, attack_distance, IsEnemySide)
    if !ArrayEmpty(arr) {
        instance_create_layer(x, y + z, "Instances", oFayMagicArrow, { 
            target: ArrayChoose(arr), shooter: id })
        reload_timer.reset()
    }
}

x = oShip.x + xrel
y = oShip.y + yrel
