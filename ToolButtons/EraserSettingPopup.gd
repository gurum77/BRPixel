extends Control

func popup_centered():
	$DraggablePopup.popup_centered()	
	$DraggablePopup/GridContainer/SizeHSlider.min_value = Define.min_thickness
	$DraggablePopup/GridContainer/SizeHSlider.max_value = Define.max_thickness
	update_controls()
	
func update_controls():
	$DraggablePopup/GridContainer/SizeHSlider.value = StaticData.eraser_thickness
	$DraggablePopup/GridContainer/SizeTextEdit.text = str(StaticData.eraser_thickness)

func _on_SizeHSlider_value_changed(value):
	StaticData.eraser_thickness = value as int
	update_controls()
	
	


func _on_SizeTextEdit_text_changed():
	var value = $DraggablePopup/GridContainer/SizeTextEdit.text.to_int()
	if value < Define.min_thickness || value > Define.max_thickness:
		return
	StaticData.eraser_thickness = value
	update_controls()
	
