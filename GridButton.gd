extends TextureRectButton


func _on_GridButton_pressed():
	StaticData.enabled_grid = pressed
	NodeManager.get_canvas().update()
	
	# save backup
	StaticData.save_auto_saved_project()

func _process(_delta):
	pressed = StaticData.enabled_grid


func _on_GridButton_gui_input(event):
	run_gui_input(event)
