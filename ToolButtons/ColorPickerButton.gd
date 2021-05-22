extends ColorPickerButton


func _ready():
	get_picker().focus_mode = Control.FOCUS_NONE
	get_popup().focus_mode = Control.FOCUS_NONE
	
func _on_ColorPickerButton_color_changed(color):
	StaticData.current_color = color
	
func _process(_delta):
	if color != StaticData.current_color:
		color = StaticData.current_color
