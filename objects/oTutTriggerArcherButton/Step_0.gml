

if place_meeting(x, y, oShip) {
	with oUIButtonDrop {
		if crew_type == oArcherBuddy {
			Show()	
		}
	}
	oUIUpgradeToArcher.Show()
    instance_destroy()
}
