extends CheckBox



func _process(delta):
	if pressed != StaticData.pixel_perfect:
		pressed = StaticData.pixel_perfect


func _on_PixelPerfectCheckBox_toggled(button_pressed):
	StaticData.pixel_perfect = button_pressed
