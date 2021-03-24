extends Panel

func _on_EditPanel_mouse_entered():
	StaticData.mouse_inside_ui = true


func _on_EditPanel_mouse_exited():
	StaticData.mouse_inside_ui = false
