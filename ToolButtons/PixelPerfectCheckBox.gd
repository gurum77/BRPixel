extends CheckButton



func _process(_delta):
	pressed = StaticData.pixel_perfect
	disabled = StaticData.pencil_thickness > 1


func _on_PixelPerfectCheckBox_toggled(button_pressed):
	StaticData.pixel_perfect = button_pressed
