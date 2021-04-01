extends TextureRect

func _ready():
	# 0,0으로 고정한다.
	rect_position = Vector2(0, 0)
	
	# 시작하면 지정된 크기로 resize를 한다
	resize()
	
# 그리드를 그린다.
func _draw():
	if StaticData.enabled_grid:
		draw_grid()
		
func draw_grid():
	var color = Color.darkgray
	var color_double_line = Color.red
	var offset = 16
	var double_line_offset = 2
	
	var idx = 0
	for x in range(0, StaticData.canvas_width, offset):
		if idx > 0 && idx % double_line_offset == 0:
			draw_line(Vector2(x, 0), Vector2(x, StaticData.canvas_height), color_double_line)
		else:
			draw_line(Vector2(x, 0), Vector2(x, StaticData.canvas_height), color)
		idx += 1
			
	idx = 0
	for y in range(0, StaticData.canvas_height, offset):
		if idx > 0 && idx % double_line_offset == 0:
			draw_line(Vector2(0, y), Vector2(StaticData.canvas_width, y), color_double_line)
		else:
			draw_line(Vector2(0, y), Vector2(StaticData.canvas_width, y), color)
		idx += 1	

# canvas를 크기를 조정한다.
# 크기에 맞게 흰색으로 만든다.
func resize():
	var image = Image.new()
	image.create(StaticData.canvas_width, StaticData.canvas_height, false, Image.FORMAT_RGBA8)
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
	
