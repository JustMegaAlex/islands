
dbg_section("Everything", true)
DebugViewAddRefs(global, [
    ["draw spawners", dbg_button, function() { global.spawners_draw_enabled = !global.spawners_draw_enabled }],
])
