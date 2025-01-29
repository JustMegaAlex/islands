/// Updates variables of debug scripts
/// It's suggested to put this into some head object
/// in which // DebugDrawVar() is called
function DebugDrawIni() {
    global.VAR_BAR_LENGTH = 0
    global.VAR_BAR_Y_BASE = 20
    global.VAR_BAR_X_BASE = 30
    global.VAR_BAR_X = 0
    global.VAR_BAR_Y = 0
    global.VAR_BAR_ROW_DELTA = 20
    global.DEBUG_DRAW_FNT = -1
    global.DEBUG = true
}

//// Use this function once per step somewhere
function DebugDrawUpdate() {
    global.VAR_BAR_LENGTH = 0
    global.VAR_BAR_X = global.VAR_BAR_X_BASE
    global.VAR_BAR_Y = global.VAR_BAR_Y_BASE
}

//// Use following functions in DrawGUI
function DebugDrawGrid(grid, x0, y0) {
    if (!global.DEBUG)
        return false
    var i, j
    draw_set_font(global.DEBUG_DRAW_FNT)
    for (i = 0; i < ds_grid_width(grid); i += 1) {
        for (j = 0; j < ds_grid_height(grid); j += 1) {
            draw_text(x0 + 50 * i, y0 + 20 * j, string(ds_grid_get(grid, i, j)))
        }
    }
}

function DebugDrawArray2d(arr, x0, y0) {
    if (!global.DEBUG)
        return false
    var i, j
    var w = array_length(arr)
    draw_set_font(global.DEBUG_DRAW_FNT)
    for (i = 0; i < w; i += 1) {
        var h = array_length(arr[i])
        for (j = 0; j < h; j += 1) {
            draw_text(x0 + 50 * i, y0 + 20 * j, string(arr[i][j]))
        }
    }
}

function DebugDrawList(list, x0, y0) {
    if (!global.DEBUG)
        return false
    var i
    for (i = 0; i < ds_list_size(list); i += 1) {
        draw_text(x0, y0 + 20 * i, string(ds_list_find_value(list, i)))
    }
}

function DebugDrawVar(text, var_) {
    if (!global.DEBUG)
        return false
	// text can be used as a var name
	if var_ == undefined {
		var_ = variable_instance_get(id, text)	
	}
    var font = draw_get_font()
    var h_allign = draw_get_halign()
    draw_set_halign(fa_left)
    global.VAR_BAR_LENGTH += 1
    draw_set_font(global.DEBUG_DRAW_FNT)
    draw_text(global.VAR_BAR_X,
        global.VAR_BAR_Y + global.VAR_BAR_LENGTH * global.VAR_BAR_ROW_DELTA,
        text + " " + string(var_)
    )
    draw_set_font(font)
    draw_set_halign(h_allign)
}




