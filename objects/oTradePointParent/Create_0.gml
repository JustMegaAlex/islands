
side = EntitySide.neutral
friendly_with = EntitySide.neutral & EntitySide.ours & EntitySide.nature

// units = []
// repeat(irandom_range(2, 4)) {
//     var unit = instance_create_layer(
//         x - 100 + random(200),
//         y - 100 + random(200),
//         layer,
//         oBuddy
//     )
//     unit.settlement = id
//     unit.side = EntitySide.neutral
//     unit.friendly_with = EntitySide.neutral & EntitySide.ours & EntitySide.nature
//     array_push(units, unit)
// }

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

function TradeAvailable() {
    return oShip.wood >= wood_cost && oShip.amber >= amber_cost
}

wood_cost = 0
amber_cost = 0
amount = 0

///// UI button
button = instance_create_layer(x, y - 140, "Instances", oUITaskButton, {settlement: id})
info_text = ""

// function RemoveUnit(ent) {
//     ArrayRemove(units, ent)
// }
