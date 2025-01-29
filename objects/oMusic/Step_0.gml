
//// Play one of two main music tracks if previous has ended
// after 5 sec silence
if (current_music == mscExploration
		or current_music == mscIntenseWaltz)
		and next_music == noone
		and !audio_is_playing(current_music_instance)
{
	var msc = current_music == mscExploration ? mscIntenseWaltz : mscExploration
	switchMusic(msc, false)
	alarm[0] = 300
}

if next_music == noone and current_music == mscBossFightStinger
		and !audio_is_playing(current_music_instance) {
    switchMusic(mscBossFight, true)
}
