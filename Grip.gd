extends Control
class_name Grip
signal moved()

enum Type{left_bottom, right_bottom, right_top, left_top}
var type = Type.left_bottom
var pressed = false
var dragging = false
var start_point:Vector2
var end_point:Vector2

var pos:Vector2
func _ready():
	if type == Type.right_bottom:
		pos.x += 1
	if type == Type.left_top:
		pos.y += 1
	if type == Type.right_top:
		pos.x += 1
		pos.y += 1
	update()
	
func _draw():
	draw_circle(pos, 1, Color.blue)
	
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
