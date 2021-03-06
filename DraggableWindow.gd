extends TextureRect
class_name DraggableWindow
var drag_position = null
var active_color
# draggable window가 submenu popup으로 사용될 경우 submenu popup 버튼을 연결해준다.
var submenu_popup_button_parent = null
export var full_screen = false
export var hide_close_button = false

func _ready():
	if full_screen:
		var size = get_viewport_rect().size
		rect_global_position = Vector2.ZERO
		rect_size = size

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
	
func popup():
	visible = true
	
func popup_centered():
	visible = true
	
#	var window_size = OS.get_window_safe_area().size
	var size = get_viewport_rect().size
	var width = size.x #ProjectSettings.get("display/window/size/width")
	var height = size.y #ProjectSettings.get("display/window/size/height")
	if full_screen:
		rect_size = size
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


