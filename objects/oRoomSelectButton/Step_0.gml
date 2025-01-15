

interacting = MouseCollision(id)

/// lightening if interaction
if interacting {
	image_index = _interact_img
	// just pressed
	if oInput.lmb_pressed {
		image_index = _checked_img
		room_goto(room_to_start)
	}
}
else {
	image_index = _default
}