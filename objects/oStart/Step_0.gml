
if audio_group_is_loaded(audio_group_msc)
		and audio_group_is_loaded(audio_group_sfx) and frames > 240 {
	room_goto(rmGame)
}
frames++
