//// If no sprite, draw a rectangle
default_color = c_white
default_rect = new Vec2(100, 100)

shadow_size = sprite_width
z = 0

velocity = new Vec2(0, 0)
position = new Vec2(x, y)
move_target = new Vec2(x, y)
sp_max = 0

is_resource = false

function IsMoving() {
    return position.dist_to(move_target) > sp_max
}
