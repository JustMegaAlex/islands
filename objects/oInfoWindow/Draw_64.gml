
draw_self()

if info {
    draw_set_font(fntInfoWindow)
    draw_set_halign(fa_left)
    draw_set_valign(fa_top)
    draw_text_ext(textx, texty, info.text, 16, text_w)
}
