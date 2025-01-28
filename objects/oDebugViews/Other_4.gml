
dbg_section("Everything", true)
DebugViewAddRefs(global, [
    ["draw spawners", dbg_button, function() 
			{ global.spawners_draw_enabled = !global.spawners_draw_enabled }],
    ["draw grid", dbg_button, function() 
    { global.draw_grid = !global.draw_grid }],
    ["camera_clamp_zoom", dbg_checkbox],
])

DebugViewAddRefs(oPlayerVision, [
    ["enabled", dbg_checkbox, "player vision"],
])
    
DebugViewAddRefs(global, [
    ["emerge", dbg_button, function() { oGen.Emerge() }],
    ["spawn enemies", dbg_button, function() { oGen.SpawnEnemies() }]
])

DebugViewAddRefs(oShip, [
    ["sp_initial", dbg_text_input, "ship speed", "f"],
    ["wood", dbg_text_input, "wood", "f"],
    ["amber", dbg_text_input, "amber", "f"],
    ["on_board_shooters_max", dbg_text_input, "shooters", "i"],
    ["add buddy", dbg_button, function() { oShip.AddBuddy() }],
    ["add archer", dbg_button, function() { oShip.AddArcher() }],
])
for (var i = 0; i < array_length(global.locked_abilities_low_tier); ++i) {
    var item = global.locked_abilities_low_tier[i]
    var struct = {inst: item, f: function() {
                                if inst.hidden {
                                    inst.Show()
                                } else {
                                    inst.Hide()
                                }
                    }
                }
    DebugViewAddRefs(item, [
        [item.name, dbg_button, struct.f],
    ])
}
for (var i = 0; i < array_length(global.locked_abilities_high_tier); ++i) {
    var item = global.locked_abilities_high_tier[i]
    var struct = {inst: item, f: function() {
                                if inst.hidden {
                                    inst.Show()
                                } else {
                                    inst.Hide()
                                }
                    }
                }
    DebugViewAddRefs(item, [
        [item.name, dbg_button, struct.f],
    ])
}
