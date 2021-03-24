extends TextureRect


func _on_ColorButton_gui_input(event):
	if event is InputEventMouseButton:
		StaticData.current_color = modulate
	
