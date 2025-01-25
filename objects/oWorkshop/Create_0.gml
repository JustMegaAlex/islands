
event_inherited()

wood_cost = RandomCost(10 + 4 * oShip.on_board_shooters_max)

info_text = $"Upgrade shooting deck\n+1 archer shooting from the ship\n{wood_cost} wd"

function Trade() {
	oShip.on_board_shooters_max++
	instance_destroy(button)
}

// function RemoveUnit(ent) {
//     ArrayRemove(units, ent)
// }
