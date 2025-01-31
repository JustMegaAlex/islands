
current_music = noone
current_music_instance = noone
next_music = noone
music_transition_time_ms = 800
next_music_transition_time_ms = music_transition_time_ms
next_music_loops = true

function switchMusic(msc, loops=true, transition_time=music_transition_time_ms) {
	next_music_transition_time_ms = transition_time
	next_music_loops = loops
	next_music = msc	
	if current_music != noone {
		if current_music == msc {
			return
		} else {
			// fade out current music
			audio_sound_gain(current_music, 0, next_music_transition_time_ms)
			// trigger next music
			alarm[0] = max(next_music_transition_time_ms / 1000 * 60, 1)
		}
	} else {
		alarm[0] = 1
	}
}

function CurrentMusic() {
	return current_music
}

audio_stop_all()
switchMusic(mscExploration, false)

audio_play_sound(mscOceanAmbience, 1, true)

//audio_play_sound(mscExploration, 0, false)