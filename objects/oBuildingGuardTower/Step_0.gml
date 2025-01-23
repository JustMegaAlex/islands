
event_inherited()

if marked_for_number_of_crew > array_length(gathering_crew) {
    GatherCrew()
}

if take_shots and !shots_timer.update() {
    if !instance_exists(attack_target) {
        attack_target = noone
        take_shots = 0
    } else {
        take_shots--
        shots_timer.reset()
        ShootAnArrow()
    }
}
