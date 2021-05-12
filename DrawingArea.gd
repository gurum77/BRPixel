extends Panel

func _ready():
	show()
	
func _on_DrawingArea_mouse_entered():
	StaticData.mouse_inside_ui = false


func _on_DrawingArea_mouse_exited():
	StaticData.mouse_inside_ui = true

func _gui_input(event):
	var nodes = NodeManager.get_tools().get_children()
	for node in nodes:
		node.drawing_area_input(event)
	
