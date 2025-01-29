
function Restart() {
	room_restart()
}

function Win() {
    oMusic.switchMusic(mscWinStinger, false, 0)
}

function Pause() {
    with oUIMenuButton { Show() }
    oControl.ui_object = oUIMenuButton
    global.pause = true
}
function Unpause() {
    with oUIMenuButton { Hide() }
    oControl.ui_object = oUIActionButtonParent
    global.pause = false
}
