
event_inherited()

amber_cost = irandom_range(5, 8)

ability = ArrayChoose(global.locked_abilities_low_tier)
info_text = ""

function Trade() {
    ability.Show()
    instance_destroy()
}

alarm[0] = 1

// function RemoveUnit(ent) {
//     ArrayRemove(units, ent)
// }
