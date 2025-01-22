

function CommandTemplate() constructor {
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

function CommandCannon() constructor {
    self.sprite = noone
    draw = function() {
        if !sprite_exists(self.sprite) { return }
        draw_sprite(sprite, 0, mouse_x, mouse_y)
    }
    perform = function() {
        if oShip.amber < global.cost_cannon_amber {
            return
        }
        oShip.amber -= global.cost_cannon_amber
        var core = instance_create_layer(
            oShip.x, oShip.y, "Instances", oCannonCore)
        core.Launch(mouse_x, mouse_y)
    }
}

function CommandCreateInstance(obj) constructor {
    self.sprite = noone
    self.obj = obj
    draw = function() {
        if !sprite_exists(self.sprite) { return }
        draw_sprite(sprite, 0, mouse_x, mouse_y)
    }
    perform = function() {
        instance_create_layer(mouse_x, mouse_y, "Instances", obj)
    }
}

function CommandFullfillTask(settlement) constructor {
    self.settlement = settlement
    self.wood = settlement.wood_cost
    self.amber = settlement.amber_cost

    perform = function() {
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
}
