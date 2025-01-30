
event_inherited()

wood_cost = RandomCost(10 + 4 * oShip.on_board_shooters_max)

info_text = "Boooo"

function Trade() {
    oShip.on_board_shooters_max++
    instance_destroy(button)
}

button.command.info = function() {
    return {
        text: $"Upgrade shooting deck.\n+1 archer shooting from the ship",
        wood_cost: id.wood_cost,
        amber_cost: id.amber_cost,
    }
}

// function RemoveUnit(ent) {
//     ArrayRemove(units, ent)
// }