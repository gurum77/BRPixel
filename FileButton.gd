extends TextureButton
class_name FileButton

export var file_name:String = ""	# 파일명만
export var directory_path = ""	# 디렉토리 경로
export var is_directory = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = file_name
	hint_tooltip = file_name
	# 빠르게 기본 썸네일을 표시하고..(pex는 빠르게 열 수 있으므로 바로 표시한다)`
	if is_directory:
		$ThumbnailTexture.texture = Define.directoryThumbnailTexture
	else:
		if is_pex_file():
			$ThumbnailTexture.texture	= get_file_thumbnail_texture()
		else:
			$ThumbnailTexture.texture	= Define.fileThumbnailTexture

	# 실제 썸네일을 그리는건 시간이 걸리므로 yield로 일단 제어를 넘기고 실제 썸네일을 그린다.
	yield(get_tree().create_timer(0.2), "timeout")
	
	if is_directory:
		$ThumbnailTexture.texture = Define.directoryThumbnailTexture
	else:
		if !is_pex_file():
			$ThumbnailTexture.texture	= get_file_thumbnail_texture()


func create_image_with_background(image:Image)->Image:
	var white_image:Image = image.duplicate()
	white_image.fill(Color.white)
	white_image.blend_rect(image, Rect2(0, 0, image.get_width(), image.get_height()), Vector2.ZERO)
	return white_image
		
# 파일의 thumbnail texture를 리턴한다.
func get_file_thumbnail_texture()->Texture:
	var file_path = get_file_path()
	if is_image_file():
		
		var image:Image = Image.new()
		var _res = image.load(file_path)
		if _res != OK:
			return Define.fileThumbnailTexture
		image = create_image_with_background(image)
		
		var texture:ImageTexture = ImageTexture.new()
		texture.create_from_image(image)
		return texture
	elif is_pex_file():
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

func is_pex_file()->bool:
	var ext = file_name.get_extension()
	if ext == "pex":
		return true
	return false
	
func is_image_file()->bool:
	var ext = file_name.get_extension()
	if ext == "png" || ext == "jpg" || ext == "jpeg" || ext == "bmp":
		return true
	return false
	
func get_file_path()->String:
	return Util.get_file_path(directory_path, file_name)
