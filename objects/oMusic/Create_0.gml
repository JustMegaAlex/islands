
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

function BGM(msc, loops=1, pause_sec=3) constructor {
    self.pause_time = pause_sec * 60
    self.msc = msc
    self.loops = loops
    self.loops_left = loops
    self.next = undefined
    self.started = false
    self.is_playing = false
    self.length_sec = audio_sound_length(msc)
	self.inst = noone
}

bgm1 = new BGM(mscExploration)
bgm2 = new BGM(mscIntenseWaltz, 4)
bgm3 = new BGM(mscBossFight, 999, 1)

bgm1.next = bgm2
bgm2.next = bgm1
bgm3.next = bgm3

bgm_current = bgm1
pause_timer = MakeTimer(bgm_current.pause_time)
check_finished_timer = MakeTimer(90)

function SwitchToEnding() {
    audio_sound_set_track_position(bgm_current.inst, bgm_current.length_sec - 3)
}

bgm_debug = {
    pos: 0,
    pos_prev: 0,
    length: 0,
    msc: noone,
}

audio_stop_all()
//switchMusic(mscExploration, false)

audio_play_sound(mscOceanAmbience, 1, true)
