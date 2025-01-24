
side = EntitySide.neutral
friendly_with = EntitySide.neutral & EntitySide.ours & EntitySide.nature

units = []
repeat(irandom_range(2, 4)) {
    var unit = instance_create_layer(
        x - 100 + random(200),
        y - 100 + random(200),
        layer,
        oBuddy
    )
    unit.settlement = id
    unit.side = EntitySide.neutral
    unit.friendly_with = EntitySide.neutral & EntitySide.ours & EntitySide.nature
    array_push(units, unit)
}

var mult = 1
if Chance(0.15) {
    mult = 0.4
} else if Chance(0.15) {
    mult = 2
} else {
    mult = random_range(0.8, 1.3)
}

wood_cost = 0
amber_cost = 0
var cost = array_length(units) * 10 * mult
var split_factor = random(1)
wood_cost = round(cost * split_factor)
amber_cost = (cost - wood_cost) div 4

///// UI button
button = instance_create_layer(x, y - 140, "Instances", oUITaskButton, {settlement: id})


function RemoveUnit(ent) {
    ArrayRemove(units, ent)
}