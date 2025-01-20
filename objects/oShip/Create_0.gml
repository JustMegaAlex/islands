event_inherited()

z = -200
sp_max = 8
hp = 16
is_creature = true
is_fighter = true
is_flying = true

drop_crew_radius = 200
drop_crew_marks = ds_list_create()
crew_instances = ds_list_create()

function AddBuddy() {
    var inst = instance_create_layer(x, y, "Instances",  oBuddy)
    LoadCrew(inst)
    return inst
}

function LoadCrew(inst) {
    array_push(crew[$ object_get_name(inst.object_index)], inst)
    instance_deactivate_object(inst)
}

function DropCrew(crew_type, xx, yy) {
    var inst = array_pop(crew[$ crew_type])
    instance_activate_object(inst)
    inst.SetPos(xx, yy)
    inst.move_target.set(xx, yy)
    inst.AttachToIsland()
}

crew = {
    oBuddy: []
}

AddBuddy(); AddBuddy();
