
function Point(_x, _y) constructor {
	x_ = _x
	y_ = _y

	static add = function(dx, dy) {
		return new Point(self.x_ + dx, self.y_ + dy)
	}
}

function Vec2(xx, yy, is_polar=false) constructor {
	x = xx
	y = yy

	add_coords = function(xx, yy) {
		self.x += xx
		self.y += yy
		return self
	}

	add_coords_ = function(xx, yy) {
		return new Vec2(self.x + xx, self.y + yy)
	}

	add = function(vec) {
		self.x += vec.x
		self.y += vec.y
		return self
	}

	add_ = function(vec) {
		return new Vec2(self.x + vec.x, self.y + vec.y)
	}

	distance_to = function(vec) {
		return point_distance(x, y, vec.x, vec.y)
	}

	sub = function(vec) {
		self.x -= vec.x
		self.y -= vec.y
		return self
	}

	sub_ = function(vec) {
		return new Vec2(self.x - vec.x, self.y - vec.y)
	}

	dir = function() {
		return point_direction(0, 0, x, y)
	}

	len = function() {
		return point_distance(0, 0, x, y)	
	}

	normalize = function(len) {
		if len == undefined
			len = 1
		var l = self.len() 
		if l == 0
			return self
		self.x *= len / l
		self.y *= len / l
		return self
	}
	
	set = function(xx, yy) {
		self.x = xx
		self.y = yy
		return self
	}

	setv = function(vec) {
		self.x = vec.x
		self.y = vec.y
		return self
	}

	set_polar = function(l, dir) {
		self.x = lengthdir_x(l, dir)
		self.y = lengthdir_y(l, dir)	
		return self
	}

	add_polar = function(l, dir) {
		self.x += lengthdir_x(l, dir)
		self.y += lengthdir_y(l, dir)
		return self
	}
	
	add_polar_ = function(l, dir) {
		return new Vec2(self.x, self.y).add_polar(l, dir)
	}

	rotated = function(angle) {
		return new Vec2(self.len(), self.dir() + angle, true)
	}
	
	rotate = function(angle) {
		self.set_polar(self.len(), self.dir() + angle)
		return self
	}
	
	copy = function() {
		return new Vec2(self.x, self.y)
	}
	
	eq = function(vec) {
		return (self.x == vec.x) and (self.y == vec.y)
	}
	
	move_to_vec = function(vec, sp_mag) {
		var delta = vec.sub_(self)
		if delta.len() < sp_mag
			return self.set(vec.x, vec.y)
		var sp = delta.normalize(sp_mag)
		return self.add(sp)
	}

	approach = function(to, sp) {
        var diff = to.sub_(self)
        var len = diff.len()
        if len == 0 or len < sp {
            self.set(to.x, to.y)
            return;
        }
		x += sp * sign(diff.x) * (abs(diff.x) / len)
		y += sp * sign(diff.y) * (abs(diff.y) / len)
		return self
	}
	
	absolutize = function() {
		x = abs(x)
		y = abs(y)
		return self
	}
	
	mult = function(n) {
		x *= n
		y *= n
		return self
	}
	
	mult_ = function(n) {
		return new Vec2(x*n, y*n)	
	}

    dist_to = function(vec) {
        return point_distance(x, y, vec.x, vec.y)
    }

    angle_to = function(vec) {
        return point_direction(x, y, vec.x, vec.y)
    }

	if is_polar == true
		self.set_polar(xx, yy)
}

vec2_zero = new Vec2(0, 0)


function Line(_xst, _yst, _xend, _yend) constructor {
	xst = _xst
	yst = _yst
	xend = _xend
	yend = _yend

	static mult = function(m) {
		xend = xst + (xend - xst) * m
		yend = yst + (yend - yst) * m
        return self
	}

	static set = function(_xst, _yst, _xend, _yend) {
		xst = _xst
		yst = _yst
		xend = _xend
		yend = _yend
        return self
	}

	static setst = function(_xst, _yst) {
		xst = _xst
		yst = _yst
        return self
	}

	static setend = function(_xend, _yend) {
		xend = _xend
		yend = _yend
        return self
	}

	static draw = function() {
		draw_line(xst, yst, xend, yend)
	}

	static get_point_on = function(m) {
		var xx = xst + (xend - xst) * m
		var yy = yst + (yend - yst) * m
		return new Vec2(xx, yy)
	}

    get_point_closest_to_point = function(px_or_vec, py_or_clamp, do_clamp=False) {
        var px, py
        if is_struct(px_or_vec) {
            px = px_or_vec.x
            py = px_or_vec.y
            do_clamp = py_or_clamp
        } else {
            px = px_or_vec
            py = py_or_clamp
        }
        // Calculate the direction vector of the line
        var dx = xend - xst;
        var dy = yend - yst;
        
        // Calculate the vector from point (x0, y0) to point (px, py)
        var vpx = px - xst;
        var vpy = py - yst;
        
        // Project the point onto the line, finding the scalar t
        var t = ((vpx * dx) + (vpy * dy)) / (dx * dx + dy * dy);
        
        // Clamp t to the range [0, 1] to ensure the point lies on the line segment
        if do_clamp {
            t = clamp(t, 0, 1);
        }

        // Calculate the closest point coordinates
        var closest_x = xst + t * dx;
        var closest_y = yst + t * dy;
        
        // Return the coordinates of the closest point
        return new Vec2(closest_x, closest_y)
	}
	
	static len = function() {
		return point_distance(xst, yst, xend, yend)
	}

	rotate = function(angle) {
		var v = new Vec2(xend - xst, yend - yst)
		v.rotate(angle)
		xend = xst + v.x
		yend = yst + v.y
		return self
	}

    rotate_relatively = function(angle, xx, yy) {
        var v = new Vec2(xst - xx, yst - yy)
        v.rotate(angle)
        xst = v.x + xx
        yst = v.y + yy
        v.set(xend - xx, yend - yy)
        v.rotate(angle)
        xend = v.x + xx
        yend = v.y + yy
        return self
    }

    angle = function() {
        return point_direction(xst, yst, xend, yend)
    }

    draw_ = function(col=c_white, width=1) {
        draw_line_width_color(xst, yst, xend, yend, width, col, col)
    }
}

function LineIntersection(l1, l2, segment) {
    // returns m parameter for l1
    var x0, y0, x1, y1, x2, y2, x3, y3
    x0 = l1.xst
    y0 = l1.yst
    x1 = l1.xend
    y1 = l1.yend
    x2 = l2.xst
    y2 = l2.yst
    x3 = l2.xend
    y3 = l2.yend
    var ua, ub, ud, ux, uy, vx, vy, wx, wy
    ua = 0
    ux = x1 - x0
    uy = y1 - y0
    vx = x3 - x2
    vy = y3 - y2

    // ensure lines are not parallel
    if vy == 0
        if uy == 0
            return infinity
    if ux / uy == vx / vy
        return infinity

    wx = x0 - x2
    wy = y0 - y2
    ud = vy * ux - vx * uy
    if (ud != 0) {
        ua = (vx * wy - vy * wx) / ud
        if (segment) {
            ub = (ux * wy - uy * wx) / ud
            if (ua <= 0 || ua >= 1 || ub <= 0 || ub >= 1)
                ua = 0
        }
    }
    return ua
}


function LineIntersection2(l1, l2, segment) {
    /*
        Same as LineIntersection, except it returns
        sturct containing both ua and ub
    */
    var x0, y0, x1, y1, x2, y2, x3, y3
    x0 = l1.xst
    y0 = l1.yst
    x1 = l1.xend
    y1 = l1.yend
    x2 = l2.xst
    y2 = l2.yst
    x3 = l2.xend
    y3 = l2.yend
    var ua, ub, ud, ux, uy, vx, vy, wx, wy
    ua = 0
    ux = x1 - x0
    uy = y1 - y0
    vx = x3 - x2
    vy = y3 - y2

    // ensure lines are not parallel
    if (vy == 0 and uy == 0)
            or ux / uy == vx / vy
        return {segm1: infinity, segm2: infinity}

    wx = x0 - x2
    wy = y0 - y2
    ud = vy * ux - vx * uy
    ua = (vx * wy - vy * wx) / ud
    ub = (ux * wy - uy * wx) / ud
    if (segment) {
        if (ua <= 0 || ua >= 1 || ub <= 0 || ub >= 1)
            ua = 0
            ub = 0
    }
    return {segm1: ua, segm2: ub}
}

zero2d = new Vec2(0, 0)

/// @desc InstanceLineCollisionPoint(x0, y0, x1, y1, inst) or InstanceLineCollisionPoint(line, inst)
function InstanceLineCollisionPoint(x0_or_line, y0_or_inst, x1, y1, inst) {
var x0, y0
if is_struct(x0_or_line) {
    x0 = x0_or_line.xst
    y0 = x0_or_line.yst
    x1 = x0_or_line.xend
    y1 = x0_or_line.yend
    inst = y0_or_inst
} else {
    x0 = x0_or_line
    y0 = y0_or_inst
}
var line = new Line(x0, y0, x1, y1)
var btm = inst.bbox_bottom
var top = inst.bbox_top
var left = inst.bbox_left
var right = inst.bbox_right

// left bound
var bound = new Line(left, btm, left, top)
var m1 = LineIntersection(line, bound, false)
// right
bound.set(right, btm, right, top)
var m2 = LineIntersection(line, bound, false)
// bottom
bound.set(left, btm, right, btm)
var m3 = LineIntersection(line, bound, false)
// top
bound.set(left, top, right, top)
var m4 = LineIntersection(line, bound, false)
// ban wrong values
if (m1 < 0) m1 = infinity
if (m2 < 0) m2 = infinity
if (m3 < 0) m3 = infinity
if (m4 < 0) m4 = infinity
// the closest point
var m = min(m1, m2, m3, m4)
if m != infinity {
    return line.get_point_on(m)
}
return undefined
}

function PointDist2d(p1, p2) {
return point_distance(p1.x, p1.y, p2.x, p2.y)
}

function PointDir2d(p1, p2) {
return point_direction(p1.x, p1.y, p2.x, p2.y)
}

function GeomDrawMultiline(points, w=1, c=c_white) {
for (var i = 0; i < array_length(points) - 1; ++i) {
    var p = points[i]
    var pp = points[i + 1]
    draw_line_width_color(p.x, p.y, pp.x, pp.y, w, c, c)
}
}
