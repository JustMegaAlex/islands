
side = EntitySide.neutral
friendly_with = EntitySide.neutral | EntitySide.ours | EntitySide.nature

function RandomCost(base) {
    var mult = 1
    if Chance(0.15) {
        mult = 0.4
    } else if Chance(0.15) {
        mult = 1.6
    } else {
        mult = random_range(0.8, 1.3)
    }
    return base * mult
}

function Trade() {

}

function Info() {
    return button.command.info()
}

function TradeAvailable() {
    return oShip.wood >= wood_cost && oShip.amber >= amber_cost
}

wood_cost = 0
amber_cost = 0
amount = 0

///// UI button
button = instance_create_layer(x, y - 140, "Instances", oUITaskButton, {settlement: id})
info_text = ""

island = instance_place(x, y, oIsland)
if island { island.AddTradePoint(id) }

alarm[0] = 1
