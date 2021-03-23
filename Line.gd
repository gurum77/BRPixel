extends Control

var pressed = false

var start_point = Vector2(0, 0)
var end_point = Vector2(0, 0)
func _ready():
	pass
	
func _draw():
	var points = get_pixels_in_line(start_point, end_point)
	StaticData.preview_layer.clear()
	StaticData.preview_layer.set_pixels_by_current_color(points)
		
	
func get_pixels_in_line(from: Vector2, to: Vector2)->Array:
	var dx = to[0] - from[0]
	var dy = to[1] - from[1]
	var nx = abs(dx)
	var ny = abs(dy)
	var signX = sign(dx)
	var signY = sign(dy)
	var p = from
	var points : Array = [p]

	var ix = 0
	var iy = 0

	while ix < nx || iy < ny:
		if (1 + (ix << 1)) * ny < (1 + (iy << 1)) * nx:
			p[0] += signX
			ix +=1
		else:
			p[1] += signY
			iy += 1
		points.append(p)
	return points
		
func _input(event):
	if StaticData.current_tool != StaticData.Tool.line:
		return
	
	if Input.is_action_just_pressed("left_button"):
		start_point = get_local_mouse_position()
		pressed = true
	elif Input.is_action_just_released("left_button"):
		end_point = get_local_mouse_position()
		var points = get_pixels_in_line(start_point, end_point)
		StaticData.current_layer.set_pixels_by_current_color(points)
		StaticData.preview_layer.clear(true)
		pressed = false
		
	if pressed:
		end_point = get_local_mouse_position()
		update()
		
		
	
		
