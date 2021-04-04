extends TextureRect
class_name Layer

export (bool) var preview_layer = false
export (bool) var minimap_layer = false
var index:int = 0
var unused:bool = false	# 사용 되지 않음.
var image:Image
enum ResizeDir{left_top, top, right_top, left, center, right, left_bottom, bottom, right_bottom}
	
# Called when the node enters the scene tree for the first time.
func _ready():
	# 0,0으로 고정한다.
	rect_position = Vector2(0, 0)
	
	texture = ImageTexture.new()
	init_size()
	update_index()
	
	if !minimap_layer: 
		if preview_layer:
			StaticData.preview_layer = self
		else:
			StaticData.current_layer = self

	
			
func set_save_dic(dic:Dictionary):
	# image를 canvas 크기에 맞게 조절
	init_size()
	
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
	if image == null:
		return false
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

func create_image(width, height)->Image:
	var tmp_image = Image.new()
	tmp_image.create(width, height, false, Image.FORMAT_RGBA8)
	return tmp_image

# 이미지의 크기를 canvas 크기로 설정한다.(이미지는 초기화 됨)
func init_size():
	image = create_image(StaticData.canvas_width, StaticData.canvas_height)
	update_texture()
# 이미지의 크기를 canvas크기로 설정한다.
# 이미지의 원본을 유지한다.
func resize(resize_dir):
	if image == null:
		init_size()
		return
	# new image
	var new_image = Image.new()
	new_image.create(StaticData.canvas_width, StaticData.canvas_height, false, Image.FORMAT_RGBA8)
	
	# image를 new_image에 복사(이동량과 함께)
	var offset_x = 0
	var offset_y = 0
	# 왼쪽으로 늘어나야 되는 경우
	# 오른쪽으로 늘어나는 경우 그냥 둔다.
	if resize_dir == ResizeDir.left || resize_dir == ResizeDir.left_bottom || resize_dir == ResizeDir.left_top:
		offset_x = StaticData.canvas_width - image.get_width()
	elif resize_dir == ResizeDir.center:
		offset_x = (StaticData.canvas_width - image.get_width())/2
		
	# 위로 늘어나냐 되는 경우
	if resize_dir == ResizeDir.top || resize_dir == ResizeDir.left_top || resize_dir == ResizeDir.right_top:
		offset_y = StaticData.canvas_height - image.get_height()
	elif resize_dir == ResizeDir.center:
		offset_y = (StaticData.canvas_height - image.get_height())/2
	
	copy_image(image, new_image, offset_x, offset_y)
	image = new_image
	update_texture()

# image의 외부인지?
func outside_of_image(var image_tmp:Image, var x:int, var y:int):
	if x < 0 || y < 0 || x >= image_tmp.get_width() || y >= image_tmp.get_height():
		return true
	return false
	
# image를 복사한다.(offset 값과 함께)
# 잘려 나갈 수 있다.
# except_transparency_pixel : 투명색은 복사하지 않는다.(원본 유지)
func copy_image(src_image:Image, target_image:Image, offset_x:int, offset_y:int, except_transparency_pixel:bool=false):
	src_image.lock()
	target_image.lock()

	var rect = Rect2(0, 0, src_image.get_width(), src_image.get_height())
	target_image.blend_rect(src_image, rect, Vector2(offset_x, offset_y))
#
#	for x in src_image.get_width():
#		for y in src_image.get_height():
#			var new_x = x + offset_x
#			var new_y = y + offset_y
#
#			if outside_of_image(target_image, new_x, new_y):
#				continue
#
#			var pixel = src_image.get_pixel(x, y)
#			target_image.set_pixel(new_x, new_y, pixel)
	src_image.unlock()
	target_image.unlock()

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
	
func erase_pixels_by_rect(rect:Rect2, inside_working_area_only = true):
	var points = GeometryMaker.get_pixels_in_rectangle(rect.position, rect.end, true)
	erase_pixels(points, inside_working_area_only)
	
func erase_pixels(points:Array, inside_working_area_only=true):
	image.lock()
	for point in points:
		if inside_working_area_only && !StaticData.inside_working_area(point):
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
