extends TextureRect

func get_format()->int:
	return NodeManager.get_save_options_popup().format

func is_sprite_sheet_method()->bool:
	return NodeManager.get_save_options_popup().sprite_sheets_method
	
# 이미지가 preview texture rect보다 큰지?
func is_big_image()->bool:
	var image_width = get_total_image_width()
	if rect_size.x < image_width:
		return true
	if rect_size.y < texture.get_height():
		return true
	return false
# 이미지 전체 폭
func get_total_image_width()->int:
	var format = get_format()
	if format == SaveOptionsPopup.Format.png:
		return StaticData.canvas_width * NodeManager.get_frames().get_frame_count()

	return StaticData.canvas_width
	
# 실제로 그려진 이미지 크기	
func get_image_size_drawn()->Vector2:
	if !is_big_image():
		return Vector2(get_total_image_width(), texture.get_height())
		
	# 이미지 크기
	var image_width = get_total_image_width()
	var image_height = texture.get_height()
	
	# preview 크기와의 비율
	var factor_x = rect_size.x / image_width
	var factor_y = rect_size.y / image_height
	
	# 더 작아 지는 크기를 반영한다
	var factor_min = min(factor_x, factor_y)
	var size = Vector2(image_width * factor_min, image_height * factor_min)
	return size
	
	
	
func _draw():
	var width = get_total_image_width()
	var height = texture.get_height()
	
	if is_big_image():
		var image_size_drawn = get_image_size_drawn()
		width = image_size_drawn.x
		height = image_size_drawn.y
	
	
	var cols = 1
	if get_format() == SaveOptionsPopup.Format.png && !is_sprite_sheet_method():
		cols = NodeManager.get_frames().get_frame_count()
		
	var rects = Util.get_rects(width, height, 1, cols)
	var x = rect_size.x / 2 - width / 2
	for rect in rects:
		rect.position.x = x
		rect.position.y = rect_size.y / 2 - height / 2
		x += rect.size.x
		draw_rect(rect, Color.blue, false)

