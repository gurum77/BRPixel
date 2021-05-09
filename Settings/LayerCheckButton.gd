extends CheckButton


func _process(_delta):
	pressed = NodeManager.get_layer_panel().visible
	


func _on_LayerCheckButton_pressed():
	NodeManager.get_layer_panel().visible = pressed
