
if is_ship_navigating {
    draw_sprite(sUINavigateArrow, 0, oShip.move_target.x, oShip.move_target.y)
}

if active_ui {
    active_ui.command.draw()
}
