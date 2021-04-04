extends Button

export var rotation_offset_degree = 45

func _on_RotateButton_pressed():
	# 선택 영역이 있어야 함
	if !StaticData.enabled_selected_area():
		Util.show_message(self, "Rotation", "No area is selected")
		return
		
	# edit 모드상태이면 
#
#	# 선택 영역을 image로 가져온다.
#	var image = Util.create_image_from_selected_area()
#
#	# image를 회전한다.
#	ImageHelper.rotxel(image, )
#
#	if horizontal_flip:
#		image.flip_x()
#	else:
#		image.flip_y()
#
