extends Button
var clipboard_button = preload("res://ToolButtons/ClipBoardButton.tscn")

func _on_CopyButton_pressed():
	if !StaticData.enabled_selected_area():
		Util.show_message(self, "No area is selected")
		
	var image = StaticData.current_layer.create_image(StaticData.selected_area.size.x, StaticData.selected_area.size.y)
	
	# layer에서 이미지 복사
	StaticData.current_layer.copy_image(StaticData.current_layer.image, image, -StaticData.selected_area.position.x, -StaticData.selected_area.position.y)
	
	
	# clip boards 노드에 추가
	var ins:Button = clipboard_button.instance()
	# 복사한 이미지를 texture rect로 만들어서 추가
	get_parent().add_child(ins)
	ins.get_node("TextureRect").texture = ImageTexture.new()
	ins.get_node("TextureRect").texture.create_from_image(image)
	ins.get_node("TextureRect").texture.flags = 0
	
	# 사이즈 조정
	get_parent().get_parent().get_parent().resize()

	
	
