
event_inherited()

default_color = c_silver
default_rect.set(80, 120)
image_xscale = 80
image_yscale = 120

is_structure = true
is_fighter = true

attack_distance = 800

crew = [1, 1, 1]
shots_timer = MakeTimer(10)
take_shots = 0
build_timer.time = 60
build_timer.timer = 60

function SpecialAttack() {
    take_shots = array_length(crew)
    shots_timer.time = min(10, attack_timer.time / (take_shots ?? 1))
}
