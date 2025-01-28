
if scan_revealed_counter {
	if !scan_in_vision and (InstDist(oShip) < oPlayerVision.vision_range) {
		scan_in_vision = true
		ScanHide(false)
	}
	if scan_in_vision and (InstDist(oShip) >= oPlayerVision.vision_range) {
		scan_in_vision = false
		ScanReveal(false)
	}
}
