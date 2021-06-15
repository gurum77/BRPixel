extends CheckButton


func _process(delta):
	pressed = StaticData.enabled_orthomode

func _on_OrthoModeCheckButton_toggled(button_pressed):
	StaticData.enabled_orthomode = button_pressed
