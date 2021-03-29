extends Panel


func _on_DrawingArea_mouse_entered():
	StaticData.mouse_inside_ui = false


func _on_DrawingArea_mouse_exited():
	StaticData.mouse_inside_ui = true
