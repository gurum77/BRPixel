extends Node


# message는 popup으로 보여준다.
func show_message(parent, title="", message=""):
	var dlg = AcceptDialog.new()
	dlg.window_title = title
	dlg.dialog_text = message
	dlg.popup_exclusive = true
	parent.add_child(dlg)
	dlg.popup_centered()
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
	var layer = StaticData.current_layer
	if use_preview_layer:
		layer = StaticData.preview_layer
		
	# 빈 이미지 생성
	var image = layer.create_image(StaticData.selected_area.size.x, StaticData.selected_area.size.y)
	
	# layer에서 이미지 복사
	layer.copy_image(layer.image, image, -StaticData.selected_area.position.x, -StaticData.selected_area.position.y)
	
	return image

# preview layer에 image를 그린다.
# preview layer는 초기화 된다.
func draw_image_on_preview_layer(image:Image, x, y):
	var preview_layer = NodeManager.get_preview_layer()
	if preview_layer == null:
		return
	preview_layer.clear()
	
	# 이미지를 preview layer에 그린다.
	preview_layer.copy_image(image, preview_layer.image, x, y)
	preview_layer.update_texture()
