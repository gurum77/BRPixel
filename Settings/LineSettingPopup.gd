extends Control


func popup_centered():
	$DraggablePopup/GridContainer/LineThicknessHSlider.min_value = Define.min_thickness
	$DraggablePopup/GridContainer/LineThicknessHSlider.max_value = Define.max_thickness

	$DraggablePopup.popup_centered()

# Called when the node enters the scene tree for the first time.
func _ready():
	update_controls()


func update_controls():
	$DraggablePopup/GridContainer/LineThicknessHSlider.value = StaticData.line_thickness
	$DraggablePopup/GridContainer/LineThicknessTextEdit.text = str(StaticData.line_thickness)

func _on_LineThicknessHSlider_value_changed(value):
	StaticData.line_thickness = value as int
	update_controls()


func _on_LineThicknessTextEdit_text_changed():
	var value = $DraggablePopup/GridContainer/LineThicknessTextEdit.text.to_int()
	if value < Define.min_thickness || value > Define.max_thickness:
		return
	StaticData.line_thickness = value
	update_controls()
