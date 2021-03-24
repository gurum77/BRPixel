extends TextureRect

func _ready():
	# 시작하면 지정된 크기로 resize를 한다
	resize()
	
	

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
	
