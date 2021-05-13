extends TextureRect
class_name DraggableWindow
var drag_position = null
var active_color
export var full_screen = false
export var hide_close_button = false
func _ready():
	if full_screen:
		var width = ProjectSettings.get("display/window/size/width")
		var height = ProjectSettings.get("display/window/size/height")
		rect_global_position = Vector2.ZERO
		rect_size.x = width
		rect_size.y = height

#	hint_tooltip = name
	active_color = self_modulate
	if hide_close_button:
		$CloseButton.hide()
	
func set_active(active):
	if active_color == null:
		return
		
	if active:
		self_modulate = active_color
	else:
		self_modulate = Color.dimgray
	
func popup_centered():
	visible = true
	
#	var window_size = OS.get_window_safe_area().size
	var width = ProjectSettings.get("display/window/size/width")
	var height = ProjectSettings.get("display/window/size/height")
	rect_global_position.x = width / 2 - rect_size.x / 2
	rect_global_position.y = height / 2 - rect_size.y / 2

func _on_DraggableWindow_gui_input(event):
	# full_screen인 경우에는 drag 하지 말자.
	if full_screen:
		return
	if event is InputEventMouseButton:
		if event.pressed:
			drag_position = get_global_mouse_position() - rect_global_position
		else:
			drag_position = null
	if event is InputEventMouseMotion and drag_position:
		rect_global_position = get_global_mouse_position() - drag_position


func _on_TextureButton_pressed():
	hide()
	if get_parent() != null:
		get_parent().hide()
