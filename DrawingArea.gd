extends Panel

func _ready():
	show()
		
func _on_DrawingArea_mouse_entered():
	StaticData.mouse_inside_ui = false


func _on_DrawingArea_mouse_exited():
	StaticData.mouse_inside_ui = true

	
	
func _gui_input(event):
	if InputManager.text_editing:
		return
	# 첫번째 lbutton up이 나올때 까지 마우스 클릭을 무시할지?
	if InputManager.ignore_first_button_up:
		if InputManager.is_action_just_pressed_lbutton(event):
			return
		if InputManager.is_action_just_released_lbutton(event):
			InputManager.ignore_first_button_up = false
			NodeManager.get_tools().run_last_drawing_tool()
			return
			
	# layer가 꺼져 있으면 클릭 이벤트 안 먹게 한다.
	if !NodeManager.get_current_layer().visible:
		if InputManager.is_action_just_released_lbutton(event):
			Util.show_message(self, "Warning", tr("Layer(%s) is hidden") % [NodeManager.get_current_layer().name], 1)
			
		if InputManager.is_action_just_pressed_lbutton(event) || InputManager.is_action_just_pressed_rbutton(event) || InputManager.is_action_just_released_lbutton(event) || InputManager.is_action_pressed_lbutton(event):
			return

	var nodes = NodeManager.get_tools().get_children()
	for node in nodes:
		node.drawing_area_input(event)
