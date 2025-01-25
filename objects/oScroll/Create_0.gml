
abilities_array = (object_index == oScroll) ? global.locked_abilities_low_tier : global.locked_abilities_high_tier
if ArrayEmpty(abilities_array) {
    show_debug_message($"{object_get_name(object_index)} create error: no abilities to unlock")
    instance_destroy()
    exit
}


event_inherited()

amber_cost = irandom_range(5, 8)

ability = ArrayChoose(abilities_array)
ArrayRemove(abilities_array, ability)

info_text = $"{ability.name} for\n{amber_cost} amb"

function Trade() {
    ability.Show()
    instance_destroy()
}

alarm[0] = 1

// function RemoveUnit(ent) {
//     ArrayRemove(units, ent)
// }
