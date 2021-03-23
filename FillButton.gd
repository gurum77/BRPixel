extends Button

func _on_FillButton_pressed():	
	StaticData.preview_layer.clear(true)
	StaticData.current_tool = StaticData.Tool.fill
