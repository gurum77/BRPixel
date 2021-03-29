extends Control
class_name Grip
signal moved()

enum Type{left_bottom, right_bottom, right_top, left_top}
var type = Type.left_bottom
var pressed = false
var dragging = false
var start_point:Vector2
var end_point:Vector2

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
	
func _draw():
	var radius = get_radius()
	draw_circle(get_local_center_position(), radius, modulate)
	
func _on_TextureRect_gui_input(event):
	if event is InputEventMouseMotion && pressed:
		end_point = get_local_mouse_position()
		drag()
		
	if Input.is_action_just_pressed("left_button"):
		start_point = get_local_mouse_position()
		update()
		pressed = true
	elif Input.is_action_just_released("left_button"):
		end_point = get_local_mouse_position()
		pressed = false
		
func drag():
	update()
	emit_signal("moved")
	pass
