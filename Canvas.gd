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
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			image.set_pixel(x, y, Color.white)
	image.unlock()
	
	texture = ImageTexture.new()
	texture.create_from_image(image)
	
