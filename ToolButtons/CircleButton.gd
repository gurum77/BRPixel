extends Button


func _on_CircleButton_pressed():
	StaticData.preview_layer.clear(true)
	StaticData.current_tool = StaticData.Tool.circle
