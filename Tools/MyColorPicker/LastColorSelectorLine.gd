extends TextureRect

onready var my_color_picker = get_parent().get_parent()
onready var last_color_selector = get_parent()

func _draw():
	if my_color_picker == null:
		return
	var x = last_color_selector.selected_x
	var y = last_color_selector.selected_y

	var selected_color = my_color_picker.get_selected_color()
	
	var draw_color = Color.gray
	# rgb 하나라도 120을 넘어가면 black으로 표시하고
	# 아니면 gray
	if Util.is_black_text(selected_color):
		draw_color = Color.black
	draw_line(Vector2(x, 0), Vector2(x, rect_size.y), draw_color)
	draw_line(Vector2(0, y), Vector2(rect_size.x, y), draw_color)
	
	var size = 6
	var rect = Rect2(x-size/2, y-size/2, size, size)
	draw_rect(rect, draw_color, false, 1)
	

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
		
		# 최종 선택 색을 지정
		var selected_color = last_color_selector.get_color_on_mouse()
		my_color_picker.change_selected_color(selected_color)
	
		update()
		last_color_selector.update()
