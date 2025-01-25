
dbg_section("Everything", true)
DebugViewAddRefs(global, [
    ["draw spawners", dbg_button, function() 
			{ global.spawners_draw_enabled = !global.spawners_draw_enabled }],
    ["draw grid", dbg_button, function() 
    { global.draw_grid = !global.draw_grid }],
    ["camera_clamp_zoom", dbg_checkbox],
    ["emerge", dbg_button, function() { oGen.Emerge() }]
])
DebugViewAddRefs(oShip, [
    ["sp_initial", dbg_text_input, "ship speed", "f"],
    ["wood", dbg_text_input, "wood", "f"],
    ["amber", dbg_text_input, "amber", "f"],
])

DebugViewAddRefs(oPlayerVision, [
    ["enabled", dbg_checkbox],
])
