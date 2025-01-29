
//// Reset all keys in mapping
var keys = variable_struct_get_names(mapping)
for (var i = 0; i < array_length(keys); ++i) {
    var key = keys[i]
    var key_actions = mapping[$ key]
    var action_names = variable_struct_get_names(key_actions)
    for (var j = 0; j < array_length(action_names); ++j) {
        key_actions[$ action_names[j]] = false
    }
}


var keys = variable_struct_get_names(mapping_config)
for (var i = 0; i < array_length(keys); ++i) {
    var key = keys[i]
    var inputs = mapping_config[$ key]
    for (var j = 0; j < array_length(inputs); ++j) {
        var input = inputs[j]
        for (var k = 0; k < array_length(input.actions); ++k) {
            /// action is [action_name, function] pair
            var action = input.actions[k]
            /// if action is already defined, skip
            if mapping[$ key][$ action[0]] {
                continue
            }
            mapping[$ key][$ action[0]] = action[1]()
        }
    }
}

//// Mouse
mouse_moved = mouse_x != mouse_x_prev or mouse_y != mouse_y_prev
mouse_x_prev = mouse_x
mouse_y_prev = mouse_y
