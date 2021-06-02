extends TextureRect


onready var last_color_selector = get_parent()

func _draw():
	var x = last_color_selector.selected_x
	var y = last_color_selector.selected_y
	var selected_color = last_color_selector.get_base_color()
	var color = last_color_selector.get_base_color()
	draw_line(Vector2(x, 0), Vector2(x, rect_size.y), color)
	draw_line(Vector2(0, y), Vector2(rect_size.x, y), color)

func _on_LastColorSelectorLine_gui_input(event):
	if InputManager.is_action_pressed_lbutton(event):
		last_color_selector.selected_x = get_local_mouse_position().x
		last_color_selector.selected_y = get_local_mouse_position().y
		if last_color_selector.selected_x < 0:
			last_color_selector.selected_x = 0
		if rect_size.x < last_color_selector.selected_x:
			last_color_selector.selected_x = rect_size.x
		if last_color_selector.selected_y < 0:
			last_color_selector.selected_y = 0
		if rect_size.y < last_color_selector.selected_y:
			last_color_selector.selected_y = rect_size.y
		
		update()
		last_color_selector.update()
