

function CommandTemplate() constructor {
    self.sprite = noone
    draw = function() {
        if !sprite_exists(self.sprite) { return }
        draw_sprite(sprite, 0, mouse_x, mouse_y)
    }
    press = function() {}
    hold = function() {}
    release = function() {}
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
    press = function() {
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
    hold = function() {}
    release = function() {}
}

function CommandCannon() constructor {
    self.sprite = noone
    self.charge_frames = 30
    self.holded_frames = 0
    self.charge_icon_angles = [0, 90, 180, 270]
    self.vec = new Vec2(0, 0)
    self.cursor_line_length = 50

    draw = function() {
        for (var i = 0; i < array_length(self.charge_icon_angles); ++i) {
            var angle = self.charge_icon_angles[i]
            var inner_radius = (self.charge_frames - self.holded_frames) * 1.5 + 20
            draw_set_color(c_black)
            draw_line_width(
                mouse_x + lengthdir_x(inner_radius, angle),
                mouse_y + lengthdir_y(inner_radius, angle),
                mouse_x + lengthdir_x(inner_radius + self.cursor_line_length, angle),
                mouse_y + lengthdir_y(inner_radius + self.cursor_line_length, angle),
                3
            )
            if self.holded_frames >= self.charge_frames {
                draw_circle(mouse_x, mouse_y, 50, true)
            }
            draw_set_color(c_white)
        }
    }
    press = function() {}
    hold = function() {
        if oShip.amber < global.cost_cannon_amber {
            self.holded_frames = 0
            return
        }
        self.holded_frames = min(self.holded_frames + 1, self.charge_frames)
    }
    release = function() {
        if self.holded_frames >= self.charge_frames {
            oShip.amber -= global.cost_cannon_amber
            var core = instance_create_layer(
                oShip.x, oShip.y, "Instances", oCannonCore)
            core.Launch(mouse_x, mouse_y)
        }
        self.holded_frames = 0
    }
}

function CommandCreateInstance(obj) constructor {
    self.sprite = noone
    self.obj = obj
    draw = function() {
        if !sprite_exists(self.sprite) { return }
        draw_sprite(sprite, 0, mouse_x, mouse_y)
    }
    press = function() {
        instance_create_layer(mouse_x, mouse_y, "Instances", obj)
    }
    hold = function() {}
    release = function() {}
}

function CommandFullfillTask(settlement) constructor {
    self.settlement = settlement
    self.wood = settlement.wood_cost
    self.amber = settlement.amber_cost

    draw = function() {}

    press = function() {
        if oShip.wood < self.wood or oShip.amber < self.amber {
            return false
        }
        oShip.wood -= self.wood
        oShip.amber -= self.amber
        for (var i = 0; i < array_length(self.settlement.units); ++i) {
            var unit = self.settlement.units[i]
            unit.side = EntitySide.ours
        }
        return true
    }
    hold = function() {}
    release = function() {}
}

function CommandCrewUpgrade(obj, amber, wood) constructor {
    self.obj = obj
    self.amber = amber
    self.wood = wood
    self.sprite = noone
    draw = function() {
        if !sprite_exists(self.sprite) { return }
        draw_sprite(sprite, 0, mouse_x, mouse_y)
    }
    press = function() {
        if oShip.amber < self.amber or oShip.wood < self.wood {
            return false
        }
        var crew = EntitiesInCircle(mouse_x, mouse_y, 5, IsCrew)
        if ArrayEmpty(crew) { return false }

        with crew[0] { instance_change(other.obj, true) }
        oShip.amber -= self.amber
        oShip.wood -= self.wood
        return true
    }
    hold = function() {}
    release = function() {}
}
