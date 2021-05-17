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
		if FileManager.is_pex_file(file_name):
			$ThumbnailTexture.texture	= FileManager.get_file_thumbnail_texture(directory_path, file_name)
		else:
			$ThumbnailTexture.texture	= Define.fileThumbnailTexture

# _ready에서 yield를 하면 경고성 Error 가 발생함.
	# 실제 썸네일을 그리는건 시간이 걸리므로 yield로 일단 제어를 넘기고 실제 썸네일을 그린다.
#	yield(get_tree().create_timer(0.2), "timeout")
#
#	if is_directory:
#		$ThumbnailTexture.texture = Define.directoryThumbnailTexture
#	else:
#		if !is_pex_file():
#			$ThumbnailTexture.texture	= get_file_thumbnail_texture()

