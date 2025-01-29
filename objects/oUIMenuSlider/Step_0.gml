
slider.set_pos(x, y)
slider.step()

if slider.has_changed {
    audio_group_set_gain(aud_group, slider.value, 0)
}


