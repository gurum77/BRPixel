extends Control
class_name Grip
signal moved()

enum Type{left_bottom, right_bottom, right_top, left_top}
var type = Type.left_bottom
var pressed = false
var dragging = false
var start_point:Vector2
var end_point:Vector2
var preview = true	# 미리보기 중인지?
var locked = false	# grip이 lock이 되면 drag를 하지않는다.

onready var camera = get_tree().root.get_node_or_null("Main/Camera")

func get_radius():
	return camera.zoom.x / 0.075
	
func get_global_center_position()->Vector2:
	return rect_position + get_local_center_position()
	
func get_local_center_position()->Vector2:
	var center_position = Vector2(0,0)
	if type == Type.right_bottom:
		center_position.x += 1
	if type == Type.left_top:
		center_position.y += 1
	if type == Type.right_top:
		center_position.x += 1
		center_position.y += 1
	return center_position
	
func _ready():
	modulate = Color.blue
	modulate.a = 0.7
	
	update()
	var err = camera.connect("zoomed", self, "on_camera_zoomed")
	if err != OK:
		print("Failure!")

func on_camera_zoomed():
	update()
	
func get_rect()->Rect2:
	var radius = get_radius()
	var center = get_local_center_position()
	center.x -= radius
	center.y -= radius
	var rect = Rect2(center, Vector2(radius*2, radius*2))
	return rect
func _draw():
	draw_rect(get_rect(), modulate, true)
#	draw_circle(get_local_center_position(), radius, modulate)
	
func is_mouse_entered()->bool:
	if preview:
		return false
		
	var mouse_position = get_local_mouse_position()
	var center_position = get_local_center_position()
	if mouse_position.distance_to(center_position) < get_radius():
		return true
	return false
	
func get_global_mouse_position_as_int()->Vector2:
	var p = get_global_mouse_position()
	p.x = p.x as int
	p.y = p.y as int
	return p
	
func lock():
	locked = true
	modulate = Color.gray
	modulate.a = 0.7
	update()
	
func _input(event):
	if preview:
		return
	if locked:
		return
	
	if event is InputEventMouseMotion:
		if pressed:
			end_point = get_global_mouse_position_as_int()
			drag()
		
	if Input.is_action_just_pressed("left_button"):
		if is_mouse_entered():
			start_point = get_global_mouse_position_as_int()
			update()
			pressed = true
			StaticData.dragging_grip = true
	elif Input.is_action_just_released("left_button"):
		if pressed:
			end_point = get_global_mouse_position_as_int()
			pressed = false		
			StaticData.dragging_grip = false
	
		
func drag():
	rect_position = end_point
	update()
	emit_signal("moved")
	pass
