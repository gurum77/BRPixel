extends Button



func _on_RectangleButton_pressed():
	StaticData.preview_layer.clear(true)
	StaticData.current_tool = StaticData.Tool.rectangle
