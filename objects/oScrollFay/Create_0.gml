

event_inherited()

amber_cost = 3 + instance_number(oFay) * 0.5
button.command = new CommandHireFay(id, amber_cost)
button.command.amber_cost = amber_cost
button.command.wood_cost = wood_cost


function Trade() {
    var pos = new Vec2(oShip.x, oShip.y)
    pos.add_polar(100, random_range(200, 340))
    instance_create_layer(pos.x, pos.y, "Instances", oFay, { z: oShip.z - random(30)})

	instance_destroy(button)
    instance_destroy()
}

function TradeAvailable() {
    return (oShip.wood >= wood_cost && oShip.amber >= amber_cost)
}

alarm[0] = 1

// function RemoveUnit(ent) {
//     ArrayRemove(units, ent)
// }
