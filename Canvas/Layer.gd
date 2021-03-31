extends TextureRect
class_name Layer

export (bool) var preview_layer = false
export (bool) var minimap_layer = false
var index:int = 0
var unused:bool = false	# 사용 되지 않음.
var image:Image
	
# Called when the node enters the scene tree for the first time.
func _ready():
	# 0,0으로 고정한다.
	rect_position = Vector2(0, 0)
	
	texture = ImageTexture.new()
	resize()
	update_index()
	
	if !minimap_layer: 
		if preview_layer:
			StaticData.preview_layer = self
		else:
			StaticData.current_layer = self

	
			
func set_save_dic(dic:Dictionary):
	# image를 canvas 크기에 맞게 조절
	resize()
	
	index = dic["index"]
	name = dic["name"]
	visible = dic["visible"]
	var array_size = dic["array_size"]
	var image_row_data = dic["image_row_data"]
	var array = Marshalls.base64_to_raw(image_row_data)
	array = array.decompress(array_size, File.COMPRESSION_DEFLATE)
	image.create_from_data(image.get_width(), image.get_height(), image.has_mipmaps(), image.get_format(), array)
	texture = ImageTexture.new()
	update_texture()
	
func get_save_dic()->Dictionary:
	var array:PoolByteArray = image.get_data()
	var array_size = array.size()
	array = array.compress(File.COMPRESSION_DEFLATE)
	var image_row_data = Marshalls.raw_to_base64(array)
	var save_dic={
		"index" : index,
		"name" : name,
		"visible" : visible,
		"array_size" : array_size,
		"image_row_data" : image_row_data,
	}
	return save_dic
	
# 저장해야 되는 layer인지?
func is_need_to_save()->bool:
	if preview_layer:
		return false
	if minimap_layer:
		return false
	return true
	
# 자신의 index를 갱신한다.
func update_index():
	var nodes = get_parent().get_children()
	index = 0
	for node in nodes:
		if self == node:
			break
		index += 1


func has_point(point:Vector2)->bool:
	if point.x < 0 || point.y < 0:
		return false
	if point.x >= image.get_width() || point.y >= image.get_height():
		return false
	return true

func toggle_visible():
	if visible:
		visible = false
	else:
		visible = true
	
# 지정된 크기에 맞게 resize를 한다.
func resize():
	image = Image.new()
	image.create(StaticData.canvas_width, StaticData.canvas_height, false, Image.FORMAT_RGBA8)
	update_texture()

# texture를 업데이트 한다.	
func update_texture():
	if image == null:
		return
	texture.create_from_image(image)
	texture.flags = 0	# filter 등 모든 롭션을 끔(2d pixel 스타일로 그려야 함)
	
func clear(var update=false):
	image.fill(Color.transparent)
	if update:
		update_texture()
	
func get_pixel(x, y)->Color:
	return image.get_pixel(x, y)
	
func erase_pixel(point):
	if !StaticData.inside_working_area(point):
		return
	image.lock()
	image.set_pixel(point.x, point.y, Color.transparent)
	image.unlock()
	update_texture()
	
func erase_pixels(points:Array):
	image.lock()
	for point in points:
		if !StaticData.inside_working_area(point):
			continue
		image.set_pixel(point.x, point.y, Color.transparent)
	image.unlock()
	update_texture()
	
func set_pixel_by_current_color(point):
	if !StaticData.inside_working_area(point):
		return
	image.lock()
	image.set_pixel(point.x, point.y, StaticData.current_color)
	image.unlock()
	update_texture()
	
func set_pixels_by_current_color(points:Array):
	image.lock()
	for point in points:
		if !StaticData.inside_working_area(point):
			continue
		image.set_pixel(point.x, point.y, StaticData.current_color)
	image.unlock()
	update_texture()
