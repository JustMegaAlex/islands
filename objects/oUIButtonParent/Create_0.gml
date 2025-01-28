
command = undefined

mouse_over = false
mouse_over_prev = false
active = false
hidden = false

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
