
function __define_methods() {
    self.sprite = noone
    active = false
    amber_cost = 0
    wood_cost = 0
    info_text = "No info about this yet"

    function info() {
        var info = {
            text: self.info_text,
        }
        if self.amber_cost > 0 {
            info.amber_cost = self.amber_cost
        }
        if self.wood_cost > 0 {
            info.wood_cost = self.wood_cost
        }
        return info
    }
    step = function() {}
    activate = function() {
        active = true
    }
    deactivate = function() {
        active = false
    }
    draw = function() {
        if !sprite_exists(self.sprite) { return }
        draw_sprite(sprite, 0, mouse_x, mouse_y)
    }
    available = function() {
        return self.cost_satisfied()
    }
    press = function() {}
    hold = function() {}
    release = function() {}
    cost_satisfied = function() {
        return oShip.amber >= amber_cost and oShip.wood >= wood_cost
    }
    take_resources = function() {
        oShip.amber -= amber_cost
        oShip.wood -= wood_cost
    }
}

function PlayCommandSound() {
    audio_play_sound(sfxUICommandRR1, 0, 0)
}

function CommandTemplate() constructor {
    self.sprite = noone
    __define_methods()
}

function CommandDropCrew(crew_type) constructor {
    __define_methods()
    self.crew_type = crew_type
    self.crew_name = crew_type == "oBuddy" ? "Buddies" : "Archers"
    show_debug_message($"{self.crew_type} {self.crew_name}")
    self.sprite = sUIDropPoint
    self.mouse_over_island = false
    self.isle = false
    self.drag_start = new Vec2(0, 0)
    self.spawn_vec = new Vec2(0, 0)
    self.amount_to_drop = 0
    self.amount_per_square_pixel = 1 / (sqr(40) * pi)
    self.drag_radius = 0
    self.check_hold_aux = 0
    self.amber_cost = -infinity
    self.wood_cost = -infinity

    info = function() {
        return {
            text: $"Drop your {crew_name}."
                  + "\nSingle click to drop 1."
                  + "\nClick + drag to drop multiple."
                  + "\nTo pick up crew use select box (left click + drag)"
        }
    }

    step = function() { 
        self.check_hold_aux--
        if self.check_hold_aux < -1 {
            self.drag_radius = 0
        }
    }
    deactivate = function() {
        self.isle = false
        self.amount_to_drop = 0
        self.drag_radius = 0
        self.active = false
    }
    activate = function() {
        self.active = true
        self.isle = false
        self.amount_to_drop = 0
        self.drag_radius = 0
    }
    draw = function() {
        if self.drag_radius > 20 {
            draw_text(self.drag_start.x, self.drag_start.y, self.amount_to_drop)
            draw_circle(self.drag_start.x, self.drag_start.y, self.drag_radius, true)
        }
        if !sprite_exists(self.sprite)
                or !self.mouse_over_island { return }
        draw_sprite(sprite, 0, mouse_x, mouse_y)
    }
    press = function() {
        self.check_hold_aux = 0
        self.isle = collision_point(mouse_x, mouse_y, oIsland, false, false)
        self.drag_start.set(mouse_x, mouse_y)
    }
    hold = function() {
        self.check_hold_aux++
        self.drag_radius = point_distance(self.drag_start.x, self.drag_start.y, mouse_x, mouse_y)
        self.amount_to_drop = self.amount_per_square_pixel * sqr(self.drag_radius) * pi
    }
    release = function() {
        if !self.isle {
            return
        }
        var crew_left = array_length(oShip.crew[$ self.crew_type])
        var crew_commanded_to_drop = 0
        with oUIMarkDrop {
            crew_commanded_to_drop += crew_type == other.crew_type
        }
        self.amount_to_drop = max(1, self.amount_to_drop)
        var gap = 30
        repeat min(self.amount_to_drop, crew_left - crew_commanded_to_drop) {
            self.spawn_vec.setv(self.drag_start)
                          .add_polar(random(self.drag_radius*0.8), random(360))
                          .clamp_coords(
                            self.isle.bbox_left + gap,
                            self.isle.bbox_right - gap,
                            self.isle.bbox_top + gap,
                            self.isle.bbox_bottom - gap)
            var mark = instance_create_layer(self.spawn_vec.x, self.spawn_vec.y, "Instances", oUIMarkDrop)
            mark.crew_type = self.crew_type
        }
        PlayCommandSound()
        self.isle = noone
        self.drag_radius = 0
    }
}

function CommandCannon() constructor {
    __define_methods()
    self.sprite = noone
    self.charge_frames = 18
    self.holded_frames = 0
    self.charge_icon_angles = [0, 90, 180, 270]
    self.vec = new Vec2(0, 0)
    self.cursor_line_length = 50
    self.amber_cost = global.cost_cannon_amber
    
    self.range_max = 1000
    self.range_min = 300

    self.draw_helper = instance_create_layer(0, 0, "OverBottom", oUICannonDraw)
    self.draw_helper.range_max = self.range_max
    self.draw_helper.range_min = self.range_min
    self.info_text = "Cannonball.\nHold to charge. Release to fire.\nOnly ground targets.\nDon't fire at your crew."

    activate = function() {
        self.active = true
        self.draw_helper.visible = true
    }
    deactivate = function() {
        self.holded_frames = 0
        self.active = false
        self.draw_helper.visible = false
    }
    draw = function() {
        for (var i = 0; i < array_length(self.charge_icon_angles); ++i) {
            var angle = self.charge_icon_angles[i]
            var inner_radius = (self.charge_frames - self.holded_frames) * 1.5 + 20
            draw_sprite_ext(sUICrosshair, 1,
                mouse_x + lengthdir_x(inner_radius, angle),
                mouse_y + lengthdir_y(inner_radius, angle),
                2, 2, angle, c_white, 1)
            if self.holded_frames >= self.charge_frames {
                draw_sprite_ext(sUICrosshair, 0, mouse_x, mouse_y,
                                2, 2, 0, c_white, 1)
            }
        }
    }
    press = function() {
        PlayCommandSound()
    }
    hold = function() {
        var dist = point_distance(oShip.x, oShip.y, mouse_x, mouse_y)
        self.holded_frames = min(self.holded_frames + 1, self.charge_frames)
                             * (dist > self.range_min and dist < self.range_max)
    }
    release = function() {
        if self.holded_frames >= self.charge_frames {
            self.take_resources()
            var core = instance_create_layer(
                oShip.x, oShip.y, "Instances", oCannonCore)
            core.Launch(mouse_x, mouse_y)
			PlaySoundAt(oShip.x, oShip.y, sfxCannonFire)
        }
        self.holded_frames = 0
    }
}

function CommandCreateInstance(obj) constructor {
    self.sprite = noone
    self.obj = obj
    __define_methods()
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

function CommandFullfillTask(inst) constructor {
    __define_methods()
    self.inst = inst
    self.amber_cost = inst.amber_cost
    self.wood_cost = inst.wood_cost
    if self.inst.object_index == oWorkshop {
        // // // Leave this comment or debugger will crash (lol)
        //// For some reason debugger crashes on Mac if 
        // Trade() is defined in oWorkshop Create
        // self.inst.Trade = function() {
        //     oShip.on_board_shooters_max++
        //     instance_destroy(button)
        // }
    }

    draw = function() {}

    available = function() {
        return self.inst.TradeAvailable()
    }

    press = function() {
        if !self.available() {
            return false
        }
        self.inst.Trade()
        self.take_resources()
        PlayCommandSound()
        return true
    }
    hold = function() {}
    release = function() {}
}

function CommandHireFay(inst, amber_cost) constructor {
    __define_methods()
    self.amber_cost = amber_cost
    self.sprite = noone
    self.inst = inst

    info_text = "Summon a Fay. Fays follows you and fight enemies."

    press = function() {
        if !self.cost_satisfied() { return false }
        self.take_resources()
        inst.Trade()
    }
}

function CommandCrewUpgrade(obj, amber, wood) constructor {
    self.obj = obj
    self.amber = amber
    self.wood = wood
    self.sprite = noone
    __define_methods()
    info = function() {
        return {
            text: $"Upgrade a buddy to an archer.\nLeft click on a buddy to upgrade."
                  + "(can upgrade when buddies are on an island)",
            amber_cost: amber,
            wood_cost: wood,
        }
    }
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
        PlayCommandSound()
        return true
    }
    hold = function() {}
    release = function() {}
}

function CommandCrewUpgrade2(inst, amber, wood) constructor {
    self.inst = inst
    self.obj = oArcherBuddy
    self.amber = amber
    self.wood = wood
    self.sprite = noone
    __define_methods()
    info = function() {
        return {
            text: $"Upgrade a buddy to an archer.\nDeploy buddies on this island to upgrade.",
            amber_cost: amber,
            wood_cost: wood,
        }
    }
    draw = function() {
        if !sprite_exists(self.sprite) { return }
        draw_sprite(sprite, 0, mouse_x, mouse_y)
    }
    available = function() {
        if !self.cost_satisfied() { return false }
        with self.inst.island {
            return place_meeting(x, y, oBuddy)
        }
    }
    press = function() {
        if !self.available() { return false }
        self.take_resources()
        with instance_nearest(inst.x, inst.y, oBuddy) { instance_change(other.obj, true) }
        PlayCommandSound()
        return true
    }
    hold = function() {}
    release = function() {}
}

function CommandPlaceBuilding(obj, wood, amber) constructor {
    __define_methods()

    /*
    
    wtf again?
    */
	self.obj = obj
    self.building_name = obj == oBuildingWatchTower ? "watch tower" : "guard tower"
    self.sprite = noone
    self.wood = wood
    self.amber = amber
    self.list = ds_list_create()

    self.checker = instance_create_layer(mouse_x, mouse_y, "Instances", oCollisionChecker)
    var inst = instance_create_layer(0, 0, "Instances", obj)
    self.building_sprite = inst.sprite_index
    self.checker.image_xscale = inst.sprite_width / self.checker.sprite_width
    self.checker.image_yscale = inst.sprite_height / self.checker.sprite_height
    InstanceDeactivate(self.checker)
    instance_destroy(inst)
    
    info_text = $"Build a {self.building_name}.\nLeft click to place.\n"
                + "Watch towers reveal distant islands"


        // // // Leave this comment or debugger will crash (lol)
        //// For some reason debugger crashes on Mac if 
        // Trade() is defined in oWorkshop Create
        // self.inst.Trade = function() {
        //     oShip.on_board_shooters_max++
        //     instance_destroy(button)
        // }

    activate = function() {
        instance_activate_object(self.checker)
    }
    deactivate = function() {
        InstanceDeactivate(self.checker)
    }
    draw = function() {
        self.checker.x = mouse_x
        self.checker.y = mouse_y
        draw_set_alpha(0.5)
        draw_sprite(self.building_sprite, 0, mouse_x, mouse_y)
        draw_set_alpha(1)
    }
    press = function() {
        if oShip.wood < self.wood or oShip.amber < self.amber {
            return false
        }
        self.checker.x = mouse_x
        self.checker.y = mouse_y
        with self.checker {
            if place_meeting(x, y, oSettlement) { return false }
            var collisions = EntitiesInRect(bbox_left, bbox_top, bbox_right, bbox_bottom,
                function(inst) { return inst.is_resource || inst.is_structure })
            if !ArrayEmpty(collisions) { return false }
        }
        oShip.wood -= self.wood
        oShip.amber -= self.amber
        instance_create_layer(mouse_x, mouse_y, "Instances", other.obj)
        PlayCommandSound()
        return true
    }
    hold = function() {}
    release = function() {}
}

function CommandTowerDropCrew(tower) constructor {
    __define_methods()

    info_text = "Release archers"
    press = tower.DropCrew
}

function CommandAmberWrath() constructor {
    self.sprite = noone
    self.amber_cost = global.cost_amber_wrath_amber
    __define_methods()
    info_text = "Unleash Enfir Wrath.\n"
    activate = function() {
        self.take_resources()
        oShip.amber_wrath_timer.reset()
        PlayCommandSound()
    }
}

function CommandHealAura() constructor {
    self.sprite = noone
    __define_methods()
    self.amber_cost = global.cost_heal_aura_amber
    info_text = "Activate healing aura.\nHeals your unboarded crew."
    activate = function() {
        self.take_resources()
        oShip.heal_aura_timer.reset()
        PlayCommandSound()
    }
}

function CommandProtectionAura() constructor {
    self.sprite = noone
    __define_methods()
    self.amber_cost = global.cost_protection_aura_amber
    info_text = "Activate protection aura.\nIncreases your crew's defense."
    activate = function() {
        self.take_resources()
        oShip.protection_aura_timer.reset()
        PlayCommandSound()
    }
}

function CommandShipRepair() constructor {
    self.sprite = noone
    __define_methods()
    self.amber_cost = global.cost_ship_repair_amber
    self.wood_cost = global.cost_ship_repair_wood
    info_text = "Repair part of your ship's damage."

    activate = function() {
        self.take_resources()
        oShip.repair_timer.reset()
        PlayCommandSound()
    }
    available = function() {
        return self.cost_satisfied() 
            and oShip.repair_timer.timer <= 0
            and oShip.hp < oShip.hp_max
    }
}

function CommandShipBoostSpeed() constructor {
    self.sprite = noone
    __define_methods()
    self.amber_cost = global.cost_speed_boost_amber
    info_text = "Activate speed boost."

    activate = function() {
        self.take_resources()
        oShip.speed_boost_timer.reset()
        PlayCommandSound()
    }
    available = function() {
        return self.cost_satisfied() 
            and oShip.speed_boost_timer.timer <= 0
    }
}

function CommandTryAgain() constructor {
    self.sprite = noone
    __define_methods()
    activate = function() {
		Restart()
    }
}

function CommandSkipTut() constructor {
    self.sprite = noone
    __define_methods()
    activate = function() {
        oGen.gen_enabled = true
        //layer_destroy_instances("TutTriggers")
        //layer_set_visible("Tutorial", false)
        with oUIActionButtonParent {
            Show()
        }
        global.playground_mode = false
		oUIButtonRetry.Hide()
		instance_destroy(oUIButtonSkipTut)
		oControl.active_ui = noone
        oControl.alarm[0] = 1
    }
}

function CommandContinue() constructor {
    __define_methods()
    activate = function() {
        deactivate()
        Unpause()
    }
}

function CommandRestart() constructor {
    __define_methods()
    activate = function() {
        Restart()
    }
}


function CommandToggleHints() constructor {
    self.sprite = noone
    __define_methods()
    activate = function() {
        with oUIHintParent {
            if hidden { Show() }
            else { Hide() }
        }
    }
}
