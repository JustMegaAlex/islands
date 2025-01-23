
event_inherited()

default_color = c_silver
default_rect.set(80, 120)
image_xscale = 80
image_yscale = 120

side = EntitySide.ours

is_structure = true
is_fighter = true

attack_distance = 800

shots_timer = MakeTimer(10)
take_shots = 0
build_timer.time = 60
build_timer.timer = 60

max_crew = 3
marked_for_number_of_crew = 0
crew = []
gathering_crew = []

function GatherCrew() {
    var island_crew = island.GetCrew()
    if !ArrayEmpty(island_crew) {
        var inst = GetClosestInstanceFromArray(island_crew)
        inst.move_to_tower = id
        array_push(gathering_crew, inst)
    }
}

function MarkForCrew() {
    if (marked_for_number_of_crew + array_length(crew)) < max_crew {
        marked_for_number_of_crew++
    } else {
        return
    }
    GatherCrew()
}

function TakeCrew(inst) {
    if ArrayEmpty(crew) {
        instance_activate_object(button)
    }
    inst.DetachFromIsland()
    array_push(crew, inst)
    ArrayRemove(gathering_crew, inst)
    instance_deactivate_object(inst)
    marked_for_number_of_crew--
}

function DropCrew() {
    var inst = array_pop(crew)
    instance_activate_object(inst)
    inst.AttachToIsland()
    if ArrayEmpty(crew) {
        instance_deactivate_object(button)
    }
}

function SpecialAttack() {
    take_shots = array_length(crew)
    shots_timer.time = min(10, attack_timer.time / (take_shots ?? 1))
}

button = instance_create_layer(x, y - 100, "Instances", oUIGuardTower, { tower: id })
instance_deactivate_object(button)
