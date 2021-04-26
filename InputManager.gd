extends Node

var pressed_lbutton = false

# 미리보기 cursor를 그린다.
# cursor는 현재 점의 크기이다.
func draw_preview_pixel_cursor(parent:Control, event, thickness):
	if event is InputEventMouseMotion:
		var point = parent.get_local_mouse_position()
		var pixels = GeometryMaker.get_pixels_in_line(point, point, thickness)
		StaticData.preview_layer.clear()
		if StaticData.current_tool == StaticData.Tool.eraser:
			var white_pixels = GeometryMaker.get_pixels_by_check_pattern(pixels, true)
			var gray_pixels = GeometryMaker.get_pixels_by_check_pattern(pixels, false)
			StaticData.preview_layer.set_pixels_by_color(white_pixels, Color.white)
			StaticData.preview_layer.set_pixels_by_color(gray_pixels, Color.gray)
		else:
			StaticData.preview_layer.set_pixels_by_current_color(pixels)
	
	
func is_action_just_pressed_rbutton(_event)->bool:
	if Input.is_action_just_pressed("right_button"):
		return true
	return false
	
func is_action_just_pressed_lbutton(event)->bool:
	# 두번 눌림현상 방지
	if pressed_lbutton:
		return false
		
	if Input.is_action_just_pressed("left_button"):
		pressed_lbutton = true
		return true
	if event is InputEventScreenTouch && event.pressed:
		pressed_lbutton = true
		return true
	return false

func is_action_just_released_lbutton(event)->bool:
	# 두번 뗌현상 방지
	if !pressed_lbutton:
		return false
		
	if Input.is_action_just_released("left_button"):
		pressed_lbutton = false
		return true
	if event is InputEventScreenTouch && !event.pressed:
		pressed_lbutton = false
		return true
	return false
	
func is_action_pressed_lbutton(event)->bool:
	if Input.is_action_pressed("left_button"):
		return true
	if event is InputEventScreenDrag:
		return true
	return false
