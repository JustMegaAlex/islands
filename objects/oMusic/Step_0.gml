
if bgm_current == noone {
    exit
}

if bgm_debug.pos != bgm_debug.pos_prev {
    audio_sound_set_track_position(bgm_debug.msc, bgm_debug.pos * bgm_debug.length)
}



if !bgm_current.started and !pause_timer.update() {
    switchMusic(bgm_current.msc, true)
    bgm_current.started = true
}
var pos = 0
if audio_is_playing(bgm_current.inst) {
	pos = audio_sound_get_track_position(bgm_current.inst)
}
if !bgm_current.is_playing 
        and audio_is_playing(bgm_current.msc)
        and pos > 2 {
    bgm_current.is_playing = true
}

/// Switch to next music
if !check_finished_timer.update() and bgm_current.is_playing and pos < 1 {
    bgm_current.loops_left--
    bgm_current.is_playing = false
    check_finished_timer.reset()
    show_debug_message($"loops left: {bgm_current.loops_left}")
    if bgm_current.loops_left <= 0 {
        show_debug_message("Switching to next music")
        bgm_current.is_playing = false
		bgm_current.started = false
        switchMusic(noone)
        bgm_current = bgm_current.next
        pause_timer.time = bgm_current.pause_time
        pause_timer.reset()
    }
}

//pos = pos / bgm_current.length_sec
bgm_debug = {
    pos_prev: pos,
    pos: pos,
    length: bgm_current.length_sec,
    msc: bgm_current.msc,
}
