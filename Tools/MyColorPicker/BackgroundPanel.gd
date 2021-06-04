extends TextureButton
class_name BackgroundPanel

# Called when the node enters the scene tree for the first time.
func _ready():
	var width = get_viewport_rect().size.x#ProjectSettings.get("display/window/size/width")
	var height = get_viewport_rect().size.y#ProjectSettings.get("display/window/size/height")
	rect_size.x = width
	rect_size.y = height
	rect_global_position.x = 0
	rect_global_position.y = 0



func _on_BackgroundPanel_visibility_changed():
	if visible:
		var width = get_viewport_rect().size.x#ProjectSettings.get("display/window/size/width")
		var height = get_viewport_rect().size.y#ProjectSettings.get("display/window/size/height")
		rect_size.x = width
		rect_size.y = height
	else:
		rect_size.x = 0
		rect_size.y = 0
