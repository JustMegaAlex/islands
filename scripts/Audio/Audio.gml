
sound_distance_gain = 1 / 3000
sound_distance_min = 1000

audio_master_gain(0.5)

function PlaySoundAt(xx, yy, snd, priority=0, loops=0) {
	var dist = point_distance(CamXCent(), CamYCent(), xx, yy)
	var gain = 1
	if dist > global.sound_distance_min {
		gain = 1 - global.sound_distance_gain * (dist - global.sound_distance_min)	
	}
	audio_play_sound(snd, priority, loops, gain)
}