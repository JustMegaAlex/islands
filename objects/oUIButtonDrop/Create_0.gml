
event_inherited()

crew_type_name = object_get_name(crew_type)
command = new CommandDropCrew(crew_type_name)
command.shortcut_key = shortcut_key

on_ship_count = 0
total_count = 0

function Info() {
    var res = command.info()
    res.text += $"\nTotal: {total_count}. On ship: {on_ship_count}"
    return res
}
