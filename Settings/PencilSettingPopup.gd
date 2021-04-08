extends Control

func popup_centered():
	$DraggablePopup.popup_centered()	
	$DraggablePopup/GridContainer/PencilThicknessHSlider.min_value = Define.min_thickness
	$DraggablePopup/GridContainer/PencilThicknessHSlider.max_value = Define.max_thickness
	update_controls()
	
func update_controls():
	$DraggablePopup/GridContainer/PencilThicknessHSlider.value = StaticData.pencil_thickness
	$DraggablePopup/GridContainer/PencilThicknessTextEdit.text = str(StaticData.pencil_thickness)

func _on_HSlider_value_changed(value):
	StaticData.pencil_thickness = value as int
	update_controls()
	
	


func _on_PencilThicknessTextEdit_text_changed():
	var value = $DraggablePopup/GridContainer/PencilThicknessTextEdit.text.to_int()
	if value < Define.min_thickness || value > Define.max_thickness:
		return
	StaticData.pencil_thickness = value
	update_controls()
	
