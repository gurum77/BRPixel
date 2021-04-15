extends LineEdit

onready var hslider = $HSlider
func _ready():
	hslider.visible = false
	hslider.min_value = Define.min_thickness
	hslider.max_value = Define.max_thickness
	
func _process(_delta):
	if text != str(StaticData.pencil_thickness):
		text = str(StaticData.pencil_thickness)
	if hslider.value != StaticData.pencil_thickness:
		hslider.value = StaticData.pencil_thickness
	


func _on_BrushSizeTextEdit_gui_input(event):
	if InputManager.is_action_just_released_lbutton(event):
		select_all()
		hslider.visible = !hslider.visible


func _on_BrushSizeTextEdit_text_changed(_new_text):
	var value = text.to_int()
	if value < Define.min_thickness || value > Define.max_thickness:
		return
	StaticData.pencil_thickness = value


func _on_HSlider_value_changed(value):
	if value < Define.min_thickness || value > Define.max_thickness:
		return
	StaticData.pencil_thickness = value
