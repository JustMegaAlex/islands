event_inherited()

z = -200
sp_max = global.ship_speed
sp_initial = sp_max
hp_max = 16
is_creature = true
is_flying = true

drop_crew_radius = 200
drop_crew_marks = ds_list_create()
crew_instances = ds_list_create()
collectibles = ds_list_create()

amber_wrath_timer = MakeTimer(120, 0)
amber_wrath_struct = {
    attack_damage: 0.5,
    object_index: noone,
}
heal_aura_timer = MakeTimer(300, 0)
protection_aura_timer = MakeTimer(300, 0)
speed_boost_timer = MakeTimer(360, 0)
repair_timer = MakeTimer(240, 0)
repair_rate = 4 / repair_timer.time
speed_boost_multiplier = 2
heal_aura_radius = 200
protection_aura_radius = 200
frame = 0

wood = global.ship_starting_wood
amber = global.ship_starting_amber

function AddBuddy() {
    var inst = instance_create_layer(x, y, "Instances",  oBuddy)
    LoadCrew(inst)
    return inst
}

function LoadCrew(inst) {
    inst.DropStateAttributes()
    array_push(crew[$ object_get_name(inst.object_index)], inst)
    instance_deactivate_object(inst)
}

function DropCrew(crew_type, xx, yy) {
    var inst = array_pop(crew[$ crew_type])
    instance_activate_object(inst)
    inst.SetPos(xx, yy)
    inst.move_target.set(xx, yy)
}

function Die() {
    visible = false
    with oUIButtonParent { Hide()}
    oUIButtonRetry.Show()
}

crew = {
    oBuddy: [],
    oArcherBuddy: [],
}

repeat global.ship_starting_crew_size {
    AddBuddy()
}
