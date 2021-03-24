extends Button

func _on_LineButton_pressed():
	StaticData.preview_layer.clear(true)
	StaticData.current_tool = StaticData.Tool.line
