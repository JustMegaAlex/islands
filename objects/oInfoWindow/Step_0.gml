
info = undefined

if oControl.mouse_over_ui and instance_exists(oControl.mouse_over_ui) {
    info = oControl.mouse_over_ui.Info()
    exit
}
var mx = window_mouse_get_x()
var my = window_mouse_get_y()
var hint = collision_point(mx, my, oUIHintParent, false, false)
if hint {
    hint.seen_by_player = true
    info = hint.Info()
    exit
}

var entity = collision_point(mouse_x, mouse_y, oEntity, false, false)
if entity {
    info = entity.Info()
    exit
}