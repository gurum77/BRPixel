extends Button

export (StaticData.SymmetryType) var symmetry_type

func _on_SymmetryButton_pressed():
	StaticData.symmetry_type = symmetry_type
	NodeManager.get_symmetry_grips().update_canvas_and_grips()
		
func _process(_delta):
	var need_to_pressed = StaticData.symmetry_type == symmetry_type
	if pressed != need_to_pressed:
		pressed = need_to_pressed
	
