extends Node

func create_image_with_background(image:Image)->Image:
	var white_image:Image = image.duplicate()
	white_image.fill(Color.white)
	white_image.blend_rect(image, Rect2(0, 0, image.get_width(), image.get_height()), Vector2.ZERO)
	return white_image
		
# 파일의 thumbnail texture를 리턴한다.
func get_file_thumbnail_texture(directory_path:String, file_name:String)->Texture:
	var file_path = get_file_path(directory_path, file_name)
	if is_image_file(file_name):
		
		var image:Image = Image.new()
		var _res = image.load(file_path)
		if _res != OK:
			return Define.fileThumbnailTexture
		image = create_image_with_background(image)
		
		var texture:ImageTexture = ImageTexture.new()
		texture.create_from_image(image)
		return texture
	elif is_pex_file(file_name):
		var open_file = File.new()
		if open_file.open(file_path, File.READ) != OK:
			return Define.fileThumbnailTexture
			
		if open_file.get_position() >= open_file.get_len():
			return Define.fileThumbnailTexture
			
		var dic:Dictionary = parse_json(open_file.get_line())
		if !dic.has("thumbnail"):
			return Define.fileThumbnailTexture
			
		var width = StaticData.get_value(dic, "canvas_width", StaticData.canvas_width)
		var height = StaticData.get_value(dic, "canvas_height", StaticData.canvas_height)
		var thumbnail_layer:Layer = Layer.new()
		thumbnail_layer.set_save_dic(dic["thumbnail"], width, height)
		thumbnail_layer.image = create_image_with_background(thumbnail_layer.image)
		thumbnail_layer.update_texture()
		
		var texture:ImageTexture = ImageTexture.new()
		texture.create_from_image(thumbnail_layer.image)
		return texture
	else:
		return Define.fileThumbnailTexture

func is_pex_file(file_name)->bool:
	var ext = file_name.get_extension()
	if ext == "pex":
		return true
	return false

func is_image_file(file_name)->bool:
	var ext = file_name.get_extension()
	if ext == "png" || ext == "jpg" || ext == "jpeg" || ext == "bmp":
		return true
	return false
	
func get_file_path(directory_path:String, file_name:String)->String:
	return Util.get_file_path(directory_path, file_name)
