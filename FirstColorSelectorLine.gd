extends TextureRect

onready var first_color_selector = get_parent()
onready var last_color_selector = get_parent().get_parent().get_node("LastColorSelector")
onready var last_color_selector_line = get_parent().get_parent().get_node("LastColorSelector/LastColorSelectorLine")
func _draw():
	var from = Vector2(first_color_selector.selected_x, 0)
	var to = Vector2(first_color_selector.selected_x, rect_size.y)
	var selected_color_line = first_color_selector.get_selected_color().blend(Color.red)
	draw_line(from, to, selected_color_line, 1)
	
# 누르고 있는 동안 계속해서 selected_color 변수를 갱신한다.
func _on_FirstColorSelectorLine_gui_input(event):
	if InputManager.is_action_pressed_lbutton(event):
		first_color_selector.selected_x = get_local_mouse_position().x
		if first_color_selector.selected_x < 0:
			first_color_selector.selected_x = 0
		if rect_size.x < first_color_selector.selected_x:
			first_color_selector.selected_x = rect_size.x
		
		update()
		last_color_selector.update()
		last_color_selector_line.update()
