extends MyColorPickerButton


func _process(_delta):
	if selected_color != StaticData.current_color:
		set_selected_color(StaticData.current_color)



func _on_MyColorPickerButton_color_changed(color):
	StaticData.current_color = color
