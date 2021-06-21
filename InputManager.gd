extends Node

var pressed_lbutton = false
var zooming = false
var text_editing = false	# 글자 입력중인지?
var ignore_first_button_up = false	# 첫번째 button up은 무시하는지?
var showing_popups = []	# 보여지고 있는 팝업
		
func remove_showing_popup(popup):
	if showing_popups.has(popup):
		showing_popups.erase(popup)
		
func add_showing_popups(popup):
	if has_showing_popup(popup):
		return
	showing_popups.append(popup)
func has_showing_popup(popup):
	return showing_popups.has(popup)
	
func is_exist_showing_popup():
	return showing_popups.size() > 0
	
# 미리보기 cursor를 그린다.
# cursor는 현재 점의 크기이다.
func draw_preview_pixel_cursor(parent:Control, event, thickness):
	if event is InputEventMouseMotion:
		var point = parent.get_local_mouse_position()
		var pixels = GeometryMaker.get_pixels_in_line(point, point, thickness)
		var pixel_with_colors = GeometryMaker.get_pixel_with_colors_by_brush_type(pixels)
		StaticData.preview_layer.clear()
		if StaticData.current_tool == StaticData.Tool.eraser:
			var white_pixels = GeometryMaker.get_pixels_by_check_pattern(pixel_with_colors.keys(), true)
			var gray_pixels = GeometryMaker.get_pixels_by_check_pattern(pixel_with_colors.keys(), false)
			StaticData.preview_layer.set_pixels_by_color(white_pixels, Color.white)
			StaticData.preview_layer.set_pixels_by_color(gray_pixels, Color.gray)
		else:
			StaticData.preview_layer.set_pixel_with_colors(pixel_with_colors)
			
# zooming 중인지?
func is_zooming()->bool:
	return zooming;
	
func is_touch_screen_zoom_event(_event)->bool:
	if _event is InputEventScreenTouch || _event is InputEventScreenDrag:
		if _event.index > 0:
			return true
	return false
	
func is_action_just_pressed_rbutton(_event)->bool:
	if is_touch_screen_zoom_event(_event):
		return false
		
	if Input.is_action_just_pressed("right_button"):
		return true
	return false
		
func is_action_just_pressed_lbutton(event)->bool:
	if is_touch_screen_zoom_event(event):
		return false
		
	if event.is_action_pressed("left_button"):
		return true
	if event is InputEventScreenTouch && event.pressed:
		return true
	return false

func is_action_just_released_lbutton(event)->bool:
	if is_touch_screen_zoom_event(event):
		return false

	if event.is_action_released("left_button"):
		return true
	if event is InputEventScreenTouch && !event.pressed:
		return true
	return false
	
func is_action_pressed_lbutton(event)->bool:
	if is_touch_screen_zoom_event(event):
		return false
		
	if Input.is_action_pressed("left_button"):
		return true
	if event is InputEventScreenDrag:
		return true
	return false
