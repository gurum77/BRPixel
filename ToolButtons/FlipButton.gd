extends Button

export var horizontal_flip = true
# 선택 영역을 flip 한다.
# 선택 영역을 유지한다.	
func _on_FlipButton_pressed():
	# 선택 영역이 있어야 함
	if !StaticData.enabled_selected_area():
		Util.show_message(self, "Flip", "No area is selected")
		return
	
	# 선택 영역을 image로 가져온다.
	var image = Util.create_image_from_selected_area()
	
	# image를 뒤집는다.
	if horizontal_flip:
		image.flip_x()
	else:
		image.flip_y()
	
	# 다시 붙여 넣는다.
	StaticData.current_layer.erase_pixels_by_rect(StaticData.selected_area)
	StaticData.current_layer.copy_image(image, StaticData.current_layer.image, StaticData.selected_area.position.x, StaticData.selected_area.position.y, true)
	StaticData.current_layer.update_texture()
	
	
