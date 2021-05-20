extends Button
class_name ClipBoardButton

# clipboard의 좌표
var clipboard_position:Vector2
var unused = false	# 사용되지 않음(삭제 예정)


func on_ClipBoardButton_pressed():
	# texturerect의 texture에서 이미지를 따옴
	var image:Image = Image.new()
	image.copy_from($TextureRect.texture.get_data())

	# clipboard가 그려질 위치
	if clipboard_position == null:
		clipboard_position = Vector2(0, 0)
	
	Util.AttachImageWithEditTool(image, clipboard_position)
