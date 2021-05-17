extends TextureButton

export var file_name:String = ""	# 파일명만
export var directory_path = ""	# 디렉토리 경로
export var is_directory = false



# Called when the node enters the scene tree for the first time.
func _ready():
	var file:File = File.new()
	$HBoxContainer/FilenameLabel.text = file_name
	var modified_time = file.get_modified_time(FileManager.get_file_path(directory_path, file_name))
	var datetime:Dictionary = OS.get_datetime_from_unix_time(modified_time)
	var year = datetime["year"]
	var month = datetime["month"]
	var day = datetime["day"]
	var hour = datetime["hour"]
	var minute = datetime["minute"]
	var second = datetime["second"]
	$HBoxContainer/ModifiedDateLabel.text = "%d-%d-%d %d:%d:%d" % [year, month, day, hour, minute, second]
		
	hint_tooltip = file_name
	# 빠르게 기본 썸네일을 표시하고..(pex는 빠르게 열 수 있으므로 바로 표시한다)`
	if is_directory:
		$HBoxContainer/ThumbnailTexture.texture = Define.directoryThumbnailTexture
	else:
		if FileManager.is_pex_file(file_name):
			$HBoxContainer/ThumbnailTexture.texture	= FileManager.get_file_thumbnail_texture(directory_path, file_name)
		else:
			$HBoxContainer/ThumbnailTexture.texture	= Define.fileThumbnailTexture


