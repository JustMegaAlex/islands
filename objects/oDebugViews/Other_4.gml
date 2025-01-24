
dbg_section("Everything", true)
DebugViewAddRefs(global, [
    ["draw spawners", dbg_button, function() 
			{ global.spawners_draw_enabled = !global.spawners_draw_enabled }],
    ["draw grid", dbg_button, function() 
    { global.draw_grid = !global.draw_grid }]
])
DebugViewAddRefs(oShip, [
    ["sp_max", dbg_text_input, "ship speed", "f"],
])
