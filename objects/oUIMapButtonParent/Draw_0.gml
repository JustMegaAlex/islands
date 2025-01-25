
var img = min(mouse_over + active * 2, 2)
if !settlement.TradeAvailable() {
    img = 3
}
draw_sprite(sprite_index, img, x, y)
