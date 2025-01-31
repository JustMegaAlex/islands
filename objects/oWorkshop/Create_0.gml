
event_inherited()

wood_cost = 8

function Trade() {
    oShip.on_board_shooters_max++
    instance_destroy(button)
}

button.command = new CommandCrewUpgrade2(id, 0, wood_cost)

// button.command.info = function() {
//     return {
//         text: $"Upgrade shooting deck.\n+1 archer shooting from the ship",
//         wood_cost: id.wood_cost,
//         amber_cost: id.amber_cost,
//     }
// }


// function RemoveUnit(ent) {
//     ArrayRemove(units, ent)
// }