extends Button


func _on_GridButton_pressed():
	StaticData.enabled_grid = !StaticData.enabled_grid
	NodeManager.get_canvas().update()
