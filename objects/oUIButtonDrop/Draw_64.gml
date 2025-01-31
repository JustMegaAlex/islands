
on_ship_count = array_length(oShip.crew[$ crew_type_name])
total_count = instance_number(crew_type) + on_ship_count
event_inherited()

draw_set_font(fntSmall)
draw_set_color(c_white)
draw_set_halign(fa_center)
draw_set_valign(fa_top)
draw_text(x, y + 36, $"{on_ship_count}/{total_count}")
