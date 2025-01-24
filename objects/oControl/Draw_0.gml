
if is_ship_navigating {
    draw_sprite(sUINavigateArrow, 0, oShip.move_target.x, oShip.move_target.y)
}

if active_ui {
    active_ui.command.draw()
}

if crew_select_box.enabled {
    draw_set_color(c_blue)
    draw_rectangle(
        crew_select_box.x0,
        crew_select_box.y0,
        crew_select_box.x1,
        crew_select_box.y1,
        true)
}

if resource_select_box.enabled {
    draw_set_color(c_green)
    draw_rectangle(
        resource_select_box.x0, 
        resource_select_box.y0, 
        resource_select_box.x1, 
        resource_select_box.y1,
        false)
}
draw_set_color(c_white)
