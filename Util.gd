extends Node

# image를 복사한다.(offset 값과 함께)
# 잘려 나갈 수 있다.
func copy_image(src_image:Image, target_image:Image, offset_x:int, offset_y:int):
	src_image.lock()
	target_image.lock()

	var rect = Rect2(0, 0, src_image.get_width(), src_image.get_height())
	target_image.blend_rect(src_image, rect, Vector2(offset_x, offset_y))

	src_image.unlock()
	target_image.unlock()
	
# file name을 확장자와 함께 리턴
func get_file_name_with_ext(file_name:String, default_ext:String, enabled_extensions:Dictionary)->String:
	var cur_ext = file_name.get_extension()
	for ext in enabled_extensions:
		if ext == cur_ext:
			return file_name

	return file_name + "." + default_ext
	
func get_file_path(directory_path, file_name)->String:
	return directory_path + file_name
	
# layer에 사용되는 image를 만든다.
# format이 중요하므로 이함수를 사용해서 만들어야 
func create_image(width, height)->Image:
	var tmp_image = Image.new()
	tmp_image.create(width, height, false, Image.FORMAT_RGBA8)
	return tmp_image

# error message를 화면에 표시한다.
func show_error_message(parent, _err):
	var message = "failed"
	show_message(parent, "Error", message)
	
# submenu popup button에 현재 툴을 설정한다.
func set_submenu_popup_button_current_tool(submenu_button:Button, current_tool):
	var parent_button:SubmenuPopupButton = submenu_button.get_parent().get_parent().get_parent()
	if parent_button != null:
		parent_button.current_tool = current_tool
		parent_button.icon = submenu_button.icon
			
# 현재 tool인 경우 버튼을 press한다
func press_current_tool_button(button, current_tool):
	var need_to_pressed = false
	if StaticData.current_tool == current_tool:
		need_to_pressed = true
	if button.pressed != need_to_pressed:
		button.pressed = need_to_pressed
	
# message는 popup으로 보여준다.
func show_message(_parent, _title="", message=""):
	NodeManager.get_message_box().enabled_yes_button = false
	NodeManager.get_message_box().enabled_no_button = false
	NodeManager.get_message_box().enabled_ok_button = true
	NodeManager.get_message_box().message = message
	NodeManager.get_message_box().popup_centered()
	
#	var dlg = AcceptDialog.new()
#	dlg.window_title = title
#	dlg.dialog_text = message
#	dlg.popup_exclusive = true
#	parent.add_child(dlg)
#	dlg.popup_centered()
#	var ins = NodeManager.preload_message_popup.instance()
#	# message는 일회성이므로 hide할때 삭제한다.
#	ins.queue_free_on_hide = true
#	parent.add_child(ins)
#	show_child_popup(parent, ins)
	
# image로 texture를 만들어서 리턴
func create_texture_from_image(image)->ImageTexture:
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	texture.flags = 0
	return texture
	
# 이미지를 복사한다.(같은 객체가 아님)
func clone_image(image:Image)->Image:
	var clone_image = Image.new()
	clone_image.copy_from(image)
	return clone_image
	
# 선택 영역을 image로 만들어서 리턴
func create_image_from_selected_area(use_preview_layer=false)->Image:
	var layer = NodeManager.get_current_layer()
	if use_preview_layer:
		layer = StaticData.preview_layer
		
	# 빈 이미지 생성
	var image = layer.create_image(StaticData.selected_area.size.x, StaticData.selected_area.size.y)
	
	# layer에서 이미지 복사
	layer.copy_image(layer.image, image, -StaticData.selected_area.position.x, -StaticData.selected_area.position.y)
	
	return image

# image 파일을 로딩한다.
# RGBA8로 만들어야 함
func load_image_file(parent:Node, path:String)->Image:
	var image = Image.new()
	var err = image.load(path)
	if err != OK:
		show_error_message(parent, err)
		return null
	var format = image.get_format()
	if format == Image.FORMAT_RGBA8:
		return image
	# format이 안 맞으면 같은 크기로 만들어서 복사해서 리턴
	var image_tmp = NodeManager.get_current_layer().create_image(image.get_width(), image.get_height())
	image.lock()
	image_tmp.lock()
	for x in image.get_width():
		for y in image.get_height():
			image_tmp.set_pixel(x, y, image.get_pixel(x, y))
	image.unlock()
	image_tmp.unlock()
	return image_tmp
	
# 그립을 만들고 edit 모드를 실행한다.
func run_edit_mode(pos:Vector2, width, height, use_preview_layer=true):
	# select 기능 실행 되어 있지 않다면 실행을 한다.
	var select:Select = NodeManager.get_tools().run_select_tool()
	
	# 이미지크기 만큼의 grip을 만든다.
	# grip을 만들면서 select area가 설정된
	select.start_point = pos
	select.end_point = pos + Vector2(width-1, height-1)
	select.make_grips(false)
	
	# edit기능을 실행한다.
	# 단 edit기능을 preview를 그대로 활용하도록 설정해야함
	NodeManager.get_tools().run_edit_tool(use_preview_layer)
	
# edit tool 모드로 image를 붙여 넣는다.
# grip / move로 편집 후 image 붙여 넣기를 완료 할 수 있다.
func AttachImageWithEditTool(image:Image, pos):
	# 미리보기에 이미지를 그린다.
	Util.draw_image_on_preview_layer(image, pos)
	
	# edit mode 실행
	Util.run_edit_mode(pos, image.get_width(), image.get_height(), true)
	
	
# preview layer에 image를 그린다.
# preview layer는 초기화 된다.
func draw_image_on_preview_layer(image:Image, pos):
	var preview_layer = NodeManager.get_preview_layer()
	if preview_layer == null:
		return
	preview_layer.clear()
	
	# 이미지를 preview layer에 그린다.
	preview_layer.init_size(max(image.get_width(), StaticData.canvas_width), max(image.get_height(), StaticData.canvas_height))
	preview_layer.copy_image(image, preview_layer.image, pos.x, pos.y)
	preview_layer.update_texture()
