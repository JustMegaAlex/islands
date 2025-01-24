
DebugDrawIni()
global.VAR_BAR_ROW_DELTA = 30

draw_set_font(fntDefault)

randomize()

with oUIButtonParent {
	if object_index != oUIButtonSkipTut {
		instance_deactivate_object(id)
	}
}
//instance_deactivate_object(oUIButtonParent)
//instance_activate_object(oUIButtonSkipTut)
