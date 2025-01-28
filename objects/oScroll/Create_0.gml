
// unseen = true

if object_index == oScroll {
    // array_push(global.unseen_low_scrolls, id)
    abilities_array = global.locked_abilities_low_tier
} else {
    // array_push(global.unseen_high_scrolls, id)
    abilities_array = global.locked_abilities_high_tier
}

if ArrayEmpty(abilities_array) {
    show_debug_message($"{object_get_name(object_index)} create error: no abilities to unlock")
    instance_destroy()
    exit
}


event_inherited()

amber_cost = irandom_range(3, 6)
button.command.amber_cost = amber_cost
button.command.wood_cost = wood_cost

ability = ArrayChoose(abilities_array)
// ArrayRemove(abilities_array, ability)

info_text = $"{ability.name} for\n{amber_cost} amb"

function Trade() {
    ability.Show()
    ArrayRemove(abilities_array, ability)
	instance_destroy(button)
    instance_destroy()
}

function TradeAvailable() {
    return (oShip.wood >= wood_cost && oShip.amber >= amber_cost)
            and ability.hidden
}

alarm[0] = 1

// function RemoveUnit(ent) {
//     ArrayRemove(units, ent)
// }
