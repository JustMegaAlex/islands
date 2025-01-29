
function UiSlider(
		spr,
        width,
        value,
        min_value,
        max_value,
		collision_raduis=-1,
        is_gui=false) constructor {
	self.spr = spr
    self.sprw = sprite_get_width(spr)
    self.sprh = sprite_get_height(spr)
    self.draw_x_off = sprw * 0.5
    self.draw_y_off = sprh * 0.5
    self.total_width = width
    self.width = max(0, width - sprw)
    self.is_gui = is_gui

    self.value = clamp(value, min_value, max_value)
	self.min_value = min_value
	self.max_value = max_value
    self.slider_rel_x = (value - min_value) / max_value * self.width

    self.prev_value = self.value
    self.has_changed = false

    self.X = 0
    self.Y = 0
	self.collision_raduis = collision_raduis
	if self.collision_raduis == -1 {
		self.collision_raduis = sprh * 0.5	
	}
	
	self.is_captured = false
	
	function set_pos(xx, yy) {
		X = xx - total_width * 0.5
		Y = yy
	}
	
	function set_value() {
		value = lerp(min_value, max_value, slider_rel_x/width)	
	}
	
	function check_is_captured() {
		return mouse_check_button_pressed(mb_left)
			   and (point_distance(X + slider_rel_x, Y, mousex(), mousey()) < collision_raduis)
	}

	function step() {
		if is_captured {
			slider_rel_x = clamp(mousex() - X, 0, width)
			set_value()
			is_captured = !mouse_check_button_released(mb_left)
		} else {
            is_captured = check_is_captured()
		}
        has_changed = false
        if prev_value != value {
            has_changed = true
            perform_hook(self)
        }
        prev_value = value
	}

    function draw() {
        draw_sprite_stretched(spr, 0, X - draw_x_off, Y - draw_y_off, total_width, sprh)
        draw_sprite(spr, 1, X + slider_rel_x, Y)
    }

    function mousex() {
        return is_gui ? window_mouse_get_x() : mouse_x
    }

    function mousey() {
        return is_gui ? window_mouse_get_y() : mouse_y
    }
	
	function perform_hook(slf) {}
}

function FullnessBar(sprite=sFullnessBar, scale=1) constructor {
    bar_fullness = 1    // change this externally or in overriden update()
    self.sprite = sprite
    sprite_width = sprite_get_width(sprite)
    sprite_height = sprite_get_height(sprite)
    self.scale = scale

    draw = function(x, y) {
        update(self)
        draw_sprite_ext(sprite, 0, x, y, scale, scale, 0, c_white, 1)
        draw_sprite_part_ext(sprite,
                        1, 0, 0, 
                        bar_fullness * sprite_width, 
                        sprite_height,
                        x, y,
                        scale, scale, c_white, 1)
    }
    // override
    udpate = function() {}
}
