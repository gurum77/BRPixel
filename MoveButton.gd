extends Button



func _on_MoveButton_pressed():
	# 현재 layer를 모두 선택하고 편집 모드를 실행한다.
	StaticData.selected_area = Rect2(0, 0, StaticData.canvas_width, StaticData.canvas_height)
	
	# edit 모드 실행
	Util.run_edit_mode(Vector2(0, 0), StaticData.canvas_width, StaticData.canvas_height, false)

