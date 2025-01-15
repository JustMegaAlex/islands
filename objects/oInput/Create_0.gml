if !EnsureSingleton() {
	exit
}

function Mouse(key) constructor {
    self.key = key
    Pressed = function() {
        return mouse_check_button_pressed(self.key)
    }
    Released = function() {
        return mouse_check_button_released(self.key)
    }
    Hold = function() {
        return mouse_check_button(self.key)
    }
    DefaultValue = function() { return false }
    actions = [
        ["pressed", Pressed],
        ["released", Released],
        ["hold", Hold],
    ]
}

function Key(key) constructor {
    self.key = key
    Pressed = function() {
        return keyboard_check_pressed(self.key)
    }
    Released = function() {
        return keyboard_check_released(self.key)
    }
    Hold = function() {
        return keyboard_check(self.key)
    }
    DefaultValue = function() { return false }
    actions = [
        ["pressed", Pressed],
        ["released", Released],
        ["hold", Hold],
    ]
}

function Gamepad(key) constructor {
    self.key = key
    Pressed = function() {
        return gamepad_button_check_pressed(oInput.gp_id, self.key)
    }
    Released = function() {
        return gamepad_button_check_released(oInput.gp_id, self.key)
    }
    Hold = function() {
        return gamepad_button_check(oInput.gp_id, self.key)
    }
    DefaultValue = function() { return false }
    actions = [
        ["pressed", Pressed],
        ["released", Released],
        ["hold", Hold],
    ]
}


function GamepadAxis(key, sign_, treshold=0) constructor {
    self.key = key
	self.treshold = treshold
	self.sign = sign_
	self.previous_value = false
    self.current_value = false
    Pressed = function() {
        // this is called first, so we assign current value here
		self.current_value = (gamepad_axis_value(oInput.gp_id, self.key) * self.sign) >= self.treshold
        return self.current_value and !self.previous_value
    }
    Released = function() {
        // this is called last, so we assign previous value here
        var result = !self.current_value and self.previous_value
        self.previous_value = self.current_value
        return result
    }
    Hold = function() {
        return self.current_value
    }
    DefaultValue = function() { return false }
    actions = [
        ["pressed", Pressed],
        ["released", Released],
        ["hold", Hold],
    ]
}

function DistinctInput(name) constructor {
    /*
    Use for a fine inputs control for specific instances
    */
    self.name = name
    self.enabled = true
    function SetEnabled(value) {
        self.enabled = value
    }
    function Pressed(key) {
        if (!self.enabled) {
            return false
        }
        return oInput.Pressed(key)
    }
    function Released(key) {
        if (!self.enabled) {
            return false
        }
        return oInput.Released(key)
    }
    function Hold(key) {
        if (!self.enabled) {
            return false
        }
        return oInput.Hold(key)
    }
}

distinct_inputs = {}
function GetDistinctInput(name) {
    var input = struct_get(distinct_inputs, name)
    if (input == undefined) {
        distinct_inputs[$ name] = new DistinctInput(name)
    }
    return distinct_inputs[$ name]
}

gp_id = -1
function DetectGamepadDevice() {
    for (var i = 0; i < gamepad_get_device_count(); i += 1) {
        if gamepad_is_connected(i) {
            gp_id = i
            return true
        }
    }
    return false
}

if !DetectGamepadDevice() {
    // retry
    alarm[0] = 30
}
gamepad_set_axis_deadzone(gp_id, 0.25)


mapping_config = {
    left: [new Key(vk_left), new Key(ord("A")),
           new Gamepad(gp_padl), new GamepadAxis(gp_axislh, -1, 0.25)],
    right: [new Key(vk_right), new Key(ord("D")),
            new Gamepad(gp_padr), new GamepadAxis(gp_axislh, 1, 0.25)],
    up: [new Key(vk_up), new Key(ord("W")), new Gamepad(gp_padu)],
    down: [new Key(vk_down), new Key(ord("S")), new Gamepad(gp_padd)],
    jump: [new Key(vk_space), new Gamepad(gp_face1)],
    dash: [new Mouse(mb_left), new Gamepad(gp_face2)],
    lclick: [new Mouse(mb_left), new Gamepad(gp_face1)],
    action: [new Mouse(mb_right)],
    interact: [new Key(ord("E"))],
    escape: [new Key(vk_escape), new Gamepad(gp_start), new Gamepad(gp_select)],
    any: [new Key(vk_anykey), new Mouse(mb_any),
          new Gamepad(gp_face1), new Gamepad(gp_face2),
          new Gamepad(gp_padu), new Gamepad(gp_padd),
          new Gamepad(gp_padr), new Gamepad(gp_padl),
    ]
}

//// Initialize key mapping
mapping = {}
var keys = variable_struct_get_names(mapping_config)
for (var i = 0; i < array_length(keys); ++i) {
    var key = keys[i]
	mapping[$ key] = {}
    var inputs = mapping_config[$ key]
    for (var j = 0; j < array_length(inputs); ++j) {
        var input = inputs[j]
        for (var k = 0; k < array_length(input.actions); ++k) {
            var action = input.actions[k]
            var def = input.DefaultValue()
            mapping[$ key][$ action[0]] = def
        }
    }
}

function Pressed(key) {
    return self.mapping[$ key].pressed
}
function Released(key) {
    return self.mapping[$ key].released
}
function Hold(key) {
    return self.mapping[$ key].hold
}

left_pressed = false
right_pressed = false
up_pressed = false
down_pressed = false
up = false
down = false
left = false
right = false
jump = false
attack = false
any = false
shoot_pressed = false
shoot = false
gp_hinp_pressed = false
gp_vinp_pressed = false
interact = false
reload = false
exit_pressed = false

dash_pressed = false
dash_released = false

gp_hinp_threshold = 0.25
gp_vinp_threshold = 0.85

scroll_down = false
scroll_up = false

//// Mouse
lmb_pressed = false
lmb_released = false
mouse_moved = false
mouse_x_prev = mouse_x
mouse_y_prev = mouse_y

active = true
function SetActive() {
    active = true
}
function SetInactive() {
    active = false
}