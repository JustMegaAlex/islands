instance_create_layer(0, 0, "Instances", oWorldEntity)
inst = instance_create_layer(0, 0, "Instances", oWorldEntity)
InstanceDeactivate(inst, id)
instance_destroy(inst)
instance_activate_object(inst)