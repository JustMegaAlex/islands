
/// @param ref - instance, object or array in form [obj, subref1, subref2, ...]
/*
Example usage:
dbg_section("Player", true)
DebugViewAddRefs(global.player, [
    ["accel", dbg_slider, 0.1, 7],
    ["walk_speed_max", dbg_slider, 4, 25],
])
/// refs for in-struct variables
DebugViewAddRefs([global.player, "animation"], [
    ["speed", dbg_slider, 0.1, 7],
    ["default_sprite", dbg_slider_int, 10, 20],
])
*/
function DebugViewAddRefs(ref, refparams) {
    var subrefs = undefined
	if is_array(ref) {
        // retrieve object and subrefs
		var _ref = array_shift(ref)
        subrefs = ref
        ref = _ref
	}
    if !instance_exists(ref) 
		and !is_struct(ref) { return }

    if is_array(subrefs) {
        // retrieve target subref
        // random example: oBus.control_struct.engine
        ref = variable_instance_get(ref, subrefs[0])
        for (var i = 1; i < array_length(subrefs); ++i) {
            ref = variable_struct_get(ref, subrefs[i])
        }
    }
    //// Add debug refs
	for (var i = 0; i < array_length(refparams); ++i) {
        var params = refparams[i]
        var name = params[0]
        var fun = params[1]
        switch array_length(params) {
            case 2:
                fun(ref_create(ref, name))
            break
            case 3:
				if fun == dbg_button {
					fun(name, params[2])
				} else {
					fun(ref_create(ref, name), params[2])
				}
            break
            case 4:
                fun(ref_create(ref, name), params[2], params[3])
            break
            default:
                throw "Wrong number of params"
        }
    }
}
