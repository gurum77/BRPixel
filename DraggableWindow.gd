extends TextureRect

var drag_position = null
var active_color
func _ready():
	hint_tooltip = name
	visible = false
	active_color = self_modulate
	
func set_active(active):
	if active_color == null:
		return
		
	if active:
		self_modulate = active_color
	else:
		self_modulate = Color.dimgray
	
func popup_centered():
	var window_size = OS.get_window_safe_area().size
	rect_global_position.x = window_size.x / 2 - rect_size.x / 2
	rect_global_position.y = window_size.y / 2 - rect_size.y / 2

func _on_DraggableWindow_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			drag_position = get_global_mouse_position() - rect_global_position
		else:
			drag_position = null
	if event is InputEventMouseMotion and drag_position:
		rect_global_position = get_global_mouse_position() - drag_position


func _on_TextureButton_pressed():
	visible = false
