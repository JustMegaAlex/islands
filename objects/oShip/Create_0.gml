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
    inst.MakeHidden()
    array_push(crew.oBuddy, inst)
    return inst
}

crew = {
    oBuddy: []
}

AddBuddy(); AddBuddy();
