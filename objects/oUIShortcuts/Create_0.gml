
map = ds_map_create()
map[? "1"] = noone
map[? "2"] = noone
map[? "3"] = noone
map[? "4"] = noone
map[? "5"] = noone
map[? "Q"] = noone
map[? "E"] = noone
map[? "F"] = noone
map[? "G"] = noone
map[? "Z"] = noone
map[? "X"] = noone
map[? "C"] = noone
map[? "V"] = noone

map_size = ds_map_size(map)
map_keys = ds_map_keys_to_array(map)

function Bind(key, inst) {
    if ds_map_exists(map, key) and map[? key] != noone {
        throw $"oUIShortcuts: key {key} already bound"
    }
    map[? key] = inst
}

function CheckShortcutUsed() {
    for (var i = 0; i < map_size; ++i) {
        var key = map_keys[i]
        if (keyboard_check_pressed(ord(key))) {
            return map[? key]
        }
    }
    return noone
}
