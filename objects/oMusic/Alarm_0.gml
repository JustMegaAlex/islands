if next_music == noone
	exit
	
audio_stop_sound(current_music)

current_music_instance = audio_play_sound(next_music, 0, next_music_loops, 0)
audio_sound_gain(current_music_instance, 0.5, next_music_transition_time_ms)
audio_sound_gain(next_music, 0.5, next_music_transition_time_ms)

current_music = next_music
next_music = noone
