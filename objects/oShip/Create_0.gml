event_inherited()

z = -200
sp_max = 8
hp = 16
is_creature = true
is_fighter = true
is_flying = true

function AddBuddy() {
    var inst = instance_create_layer(x, y, "Instances",  oBuddy)
    inst.MakeHidden()
    array_push(crew.buddies, inst)
    return inst
}

crew = {
    buddies: []
}

AddBuddy();AddBuddy();AddBuddy()
