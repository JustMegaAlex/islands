
event_inherited()

wood_cost = RandomCost(4)
amber_cost = RandomCost(0.5)
amount = irandom_range(2, 6)

info_text = $"One buddy for\n{wood_cost} wd\n{amber_cost} amb"

function Trade() {
    var pos = new Vec2(x, y)
    pos.add_polar(200, random(360))
    instance_create_layer(
        pos.x,
        pos.y,
        "Instances",
        oBuddy)
}

// function RemoveUnit(ent) {
//     ArrayRemove(units, ent)
// }
