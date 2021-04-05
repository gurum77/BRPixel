extends Button


# 선택한 영역을 지운다.
func _on_DeleteButton_pressed():
	if !StaticData.enabled_selected_area():
		return
	var points = GeometryMaker.get_pixels_in_rectangle(StaticData.selected_area.position, StaticData.selected_area.end)
	StaticData.current_layer.erase_pixels(points)
