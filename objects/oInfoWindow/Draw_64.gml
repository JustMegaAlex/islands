
draw_self()

if info {
    draw_set_font(fntInfoWindow)
    draw_set_halign(fa_left)
    draw_set_valign(fa_top)
    draw_text_ext(textx, texty, info.text, 22, text_w)
    var amber = struct_get(info, "amber_cost")
    var wood = struct_get(info, "wood_cost")
    var shortcut_key = struct_get(info, "shortcut_key")
    var yy = bbox_bottom - 24
    var xx = textx + 16
    var scale = 0.66
    draw_set_valign(fa_middle)
    if amber != undefined {
        draw_sprite_ext(sCollectibleAmber, 0, xx, yy, scale, scale, 0, c_white, 1)
        draw_text(xx + 24, yy, amber)
    }
    xx += 100
    if wood != undefined {
        draw_sprite_ext(sCollectibleWood, 0, xx, yy, scale, scale, 0, c_white, 1)
        draw_text(xx + 24, yy, wood)
    }
    if shortcut_key != undefined and shortcut_key != "" {
        xx = round(bbox_right - 24)
        yy = round(bbox_bottom - 24)
        draw_sprite(sUIHintShortcutIcon, 0, xx, yy)
        draw_set_halign(fa_center)
        draw_set_valign(fa_middle)
        draw_text(xx, yy, shortcut_key)
    }
}
