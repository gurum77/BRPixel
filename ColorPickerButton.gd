extends ColorPickerButton


func _on_ColorPickerButton_color_changed(color):
	StaticData.current_color = color
