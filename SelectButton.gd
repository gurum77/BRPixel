extends Button

func _on_SelectButton_pressed():
	StaticData.preview_layer.clear(true)
	StaticData.current_tool = StaticData.Tool.select
