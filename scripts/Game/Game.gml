
function Restart() {
	ResetGlobals()
	room_restart()
}

function Win() {
    oMusic.Victory()
    global.victory = true
    with oEnemyHarpy { instance_destroy() }
    with oEnemyCrawlp { instance_destroy() }
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
