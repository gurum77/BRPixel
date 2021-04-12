extends TextureRect

func _ready():
	# 0,0으로 고정한다.
	rect_position = Vector2(0, 0)
	
	# 시작하면 지정된 크기로 resize를 한다
	resize()
	
# 그리드를 그린다.
func _draw():
	if StaticData.enabled_tilemode:
		draw_tile_check_patterns()
	if StaticData.enabled_grid:
		draw_grid()
		
func draw_tile_check_patterns():
	var rect = Rect2(-StaticData.canvas_width, -StaticData.canvas_height, StaticData.canvas_width * 3, StaticData.canvas_height * 3)
	draw_texture_rect(texture, rect, true)
	
func draw_grid_by_position_offset(position_offset):
	var color = Color.darkgray
	var color_double_line = Color.red
	var offset = 16
	var double_line_offset = 2
	
	
	var idx = 0
	for x in range(0, StaticData.canvas_width, offset):
		if idx > 0 && idx % double_line_offset == 0:
			draw_line(position_offset + Vector2(x, 0), position_offset + Vector2(x, StaticData.canvas_height), color_double_line)
		else:
			draw_line(position_offset + Vector2(x, 0), position_offset + Vector2(x, StaticData.canvas_height), color)
		idx += 1
			
	idx = 0
	for y in range(0, StaticData.canvas_height, offset):
		if idx > 0 && idx % double_line_offset == 0:
			draw_line(position_offset + Vector2(0, y), position_offset + Vector2(StaticData.canvas_width, y), color_double_line)
		else:
			draw_line(position_offset + Vector2(0, y), position_offset + Vector2(StaticData.canvas_width, y), color)
		idx += 1		
		
func draw_grid():
	draw_grid_by_position_offset(Vector2(0, 0))
	if StaticData.enabled_tilemode:
		var position_offsets = NodeManager.get_tile_mode_manager().get_tiles_position_offsets()
		for po in position_offsets:
			draw_grid_by_position_offset(po)
		# tile mode라면 가운데(원래 grid) 테두리를 파랗게 그려준다.
		var pline = []
		pline.append(Vector2(0, 0))
		pline.append(Vector2(StaticData.canvas_width, 0))
		pline.append(Vector2(StaticData.canvas_width, StaticData.canvas_height))
		pline.append(Vector2(0, StaticData.canvas_height))
		pline.append(Vector2(0, 0))
		draw_polyline(pline, Color.blue)
	
	
	
	

# canvas를 크기를 조정한다.
# 크기에 맞게 흰색으로 만든다.
func resize():
	var image = Image.new()
	
	var width = StaticData.canvas_width
	var height = StaticData.canvas_height
		
	image.create(width, height, false, Image.FORMAT_RGBA8)
	image.lock()
	
	# white
	for y in range(0, image.get_height(), 2):
		for x in range(0, image.get_width(), 2):
			image.set_pixel(x, y, Color.white)
	for y in range(1, image.get_height(), 2):
		for x in range(1, image.get_width(), 2):
			image.set_pixel(x, y, Color.white)
	
	# gray
	for y in range(0, image.get_height(), 2):
		for x in range(1, image.get_width(), 2):
			image.set_pixel(x, y, Color.lightgray)
	for y in range(1, image.get_height(), 2):
		for x in range(0, image.get_width(), 2):
			image.set_pixel(x, y, Color.lightgray)
	
	image.unlock()
	
	texture = ImageTexture.new()
	texture.create_from_image(image)
	texture.flags = 0
	
	
