event_inherited()

side = EntitySide.ours

SetFriendlyWith(EntitySide.ours)
SetFriendlyWith(EntitySide.neutral)

z = -200
sp_max = global.ship_speed
sp_initial = sp_max
hp_max = global.ship_hp
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

on_board_shooters = 0
on_board_shooters_max = 0
on_board_shooters_range = 600
on_board_shooters_timer = MakeTimer(60, 0)
on_board_shooters_shots_timer = MakeTimer(10, 0)
take_shots = 0
on_board_shooters_targets = []

function ShootAnArrow(target) {
    instance_create_layer(x, y + z, "Instances", oArrow, 
                          { shooter: id, target: target })
}

function OnBoardShooters() {
    on_board_shooters = min(on_board_shooters_max, array_length(crew.oArcherBuddy))
    if on_board_shooters == 0 {
        return
    }
    if !on_board_shooters_timer.update() {
		on_board_shooters_timer.reset()
        take_shots = on_board_shooters
    }
    if take_shots {
        if !on_board_shooters_shots_timer.update() {
            ///// clean from dead bodies
            for (var i = 0; i < array_length(on_board_shooters_targets); ++i) {
                if !instance_exists(on_board_shooters_targets[i]) {
                    array_delete(on_board_shooters_targets, i, 1)
                    i--
                }
            }
            ///// add up to max shooters
            if array_length(on_board_shooters_targets) < on_board_shooters {
                var targets = EntitiesInCircle(x, y, on_board_shooters_range,
                                            function(inst) {
                                                return IsEnemySide(inst)
                                            })
                if !ArrayEmpty(targets) repeat on_board_shooters - array_length(on_board_shooters_targets) {
                    array_push(on_board_shooters_targets, ArrayChoose(targets))
                }
            }
            ///// shoot
            var size = array_length(on_board_shooters_targets)
            if size {
                take_shots--
                on_board_shooters_shots_timer.reset()
                ShootAnArrow(on_board_shooters_targets[min(size-1, take_shots)])
            }
        }
    }
}

function AddBuddy() {
    var inst = instance_create_layer(x, y, "Instances",  oBuddy)
    LoadCrew(inst)
    return inst
}

function AddArcher() {
    var inst = instance_create_layer(x, y, "Instances",  oArcherBuddy)
    LoadCrew(inst)
    return inst
}

function LoadCrew(inst) {
    on_board_shooters += inst.is_shooter * (on_board_shooters < on_board_shooters_max)
    on_board_shooters_shots_timer.time = min(10, 40 / on_board_shooters)
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

is_dead = false
function Die() {
	if is_dead { return }
    is_dead = true
    visible = false
    with oUIButtonParent { Hide()}
    oUIButtonRetry.Show()
    oMusic.switchMusic(mscLooseStinger, false, 0)
}

crew = {
    oBuddy: [],
    oArcherBuddy: [],
}

repeat global.ship_starting_crew_size {
    AddBuddy()
}
