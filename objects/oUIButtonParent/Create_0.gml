
command = undefined

mouse_over = false
active = false
hidden = false
name = ""

function Deactivate() {
    active = false
    command.deactivate()
}

function Hide() {
    hidden = true
    x = -1000
    y = -1000
}

function Show() {
    hidden = false
    x = xstart
    y = ystart
}

alarm[0] = 1
