
is_ship_navigating = false

mx = 0
my = 0
active_ui = noone

function Command() constructor {
    self.sprite = noone
    draw = function() {
        if !sprite_exists(self.sprite) { return }
        draw_sprite(sprite, 0, mouse_x, mouse_y)
    }
    perform = function() {}
}

function CommandDropCrew(crew_type) constructor {
    self.crew_type = crew_type
    self.sprite = sUIMarkDrop
    self.mosue_over_island = false

    draw = function() {
        if !sprite_exists(self.sprite)
                or !self.mosue_over_island { return }
        draw_sprite(sprite, 0, mouse_x, mouse_y)
    }
    perform = function() {
        self.mosue_over_island = collision_point(mouse_x, mouse_y, oIsland, false, false)
        if !self.mosue_over_island {
            return
        }
        var crew_left = array_length(oShip.crew[$ self.crew_type])
        var crew_commanded_to_drop = 0
        with oUIMarkDrop {
            crew_commanded_to_drop += crew_type == other.crew_type
        }
        if crew_left > crew_commanded_to_drop {
            var mark = instance_create_layer(mouse_x, mouse_y, "Instances", oUIMarkDrop)
            mark.crew_type = self.crew_type
        }
    }
}
