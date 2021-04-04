extends Button
class_name ClipBoardButton

# clipboard의 좌표
var clipboard_position:Vector2
var unused = false	# 사용되지 않음(삭제 예정)

func _on_ClipBoardButton_pressed():
	# texturerect의 texture에서 이미지를 따옴
	var image:Image = Image.new()
	image.copy_from($TextureRect.texture.get_data())
	
	# select 기능 실행 되어 있지 않다면 실행을 한다.
	var select:Select = NodeManager.get_tools().run_select_tool()
	
	# clipboard가 그려질 위치
	if clipboard_position == null:
		clipboard_position = Vector2(0, 0)
	
	# 이미지크기 만큼의 grip을 만든다.
	# grip을 만들면서 select area가 설정된
	select.start_point = clipboard_position
	select.end_point = clipboard_position + Vector2(image.get_width(), image.get_height())
	select.make_grips(false)
	
	# 미리보기에 이미지를 그린다.
	Util.draw_image_on_preview_layer(image, clipboard_position.x, clipboard_position.y)

	# edit기능을 실행한다.
	# 단 edit기능을 preview를 그대로 활용하도록 설정해야함
	NodeManager.get_tools().run_edit_tool(true)
	
