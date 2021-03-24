extends Button


func _on_EraserButton_pressed():
	StaticData.preview_layer.clear(true)
	StaticData.current_tool = StaticData.Tool.eraser
