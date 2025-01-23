event_inherited()

z = -200
sp_max = global.ship_speed
hp_max = 16
is_creature = true
is_flying = true

drop_crew_radius = 200
drop_crew_marks = ds_list_create()
crew_instances = ds_list_create()
collectibles = ds_list_create()

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

crew = {
    oBuddy: [],
    oArcher: [],
}

repeat global.ship_starting_crew_size {
    AddBuddy()
}
