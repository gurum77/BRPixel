extends CheckButton

func _on_PreviewCheckButton_pressed():
	NodeManager.get_preview().visible = pressed
	
func _process(_delta):
	pressed = NodeManager.get_preview().visible
	
