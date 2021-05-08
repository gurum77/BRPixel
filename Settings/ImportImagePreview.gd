extends TextureRect

export var cols = 1
export var rows = 1

# 이미지가 preview texture rect보다 큰지?
func is_big_image()->bool:
	var image_height = texture.get_width()
	var image_width = texture.get_height()
	if rect_size.x < image_width:
		return true
	if rect_size.y < image_height:
		return true
	return false
	
# 실제로 그려진 이미지 크기	
func get_image_size_drawn()->Vector2:
	if !is_big_image():
		return Vector2(texture.get_width(), texture.get_height())
		
	# 이미지 크기
	var image_width = texture.get_width()
	var image_height = texture.get_height()
	
	# preview 크기와의 비율
	var factor_x = rect_size.x / image_width
	var factor_y = rect_size.y / image_height
	
	# 더 작아 지는 크기를 반영한다
	var factor_min = min(factor_x, factor_y)
	var size = Vector2(image_width * factor_min, image_height * factor_min)
	return size


func _draw():
	var width = texture.get_width()
	var height = texture.get_height()
	
	if is_big_image():
		var image_size_drawn = get_image_size_drawn()
		width = image_size_drawn.x
		height = image_size_drawn.y
	
	
	var rects = Util.get_rects(width, height, rows, cols)
	var x_offset = rect_size.x / 2 - width / 2
	var y_offset = rect_size.y / 2 - height / 2
	for rect in rects:
		rect.position.x += x_offset
		rect.position.y += y_offset
		draw_rect(rect, Color.blue, false)
