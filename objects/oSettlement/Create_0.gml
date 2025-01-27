
event_inherited()

wood_cost = RandomCost(4)
amber_cost = RandomCost(0.5)
amount = irandom_range(2, 6)

info_text = $"One buddy for\n{wood_cost} wd\n{amber_cost} amb\n{amount} left"

function Trade() {
    var pos = new Vec2(x, y)
    pos.add_polar(100, random(360))
    var buddy = instance_create_layer(
        pos.x,
        pos.y,
        "Instances",
        oBuddy)
    var tries = 100
    with buddy {
        while !place_meeting(x, y, oIsland) {
            x = other.x + irandom_range(-100, 100)
            y = other.y + irandom_range(-100, 100)
            if !--tries {
                show_debug_message("oSettlement buddy create error: failed to place on an island")
                instance_destroy()
                exit
            }
        }
    }
    if !--amount {
        instance_destroy(button)
    }
    oShip.amber -= amber_cost
    oShip.wood -= wood_cost
}

// function RemoveUnit(ent) {
//     ArrayRemove(units, ent)
// }