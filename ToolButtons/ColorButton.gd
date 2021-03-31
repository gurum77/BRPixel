extends TextureRect

var empty_color = true
onready var current_color_sign = $CurrentColorSign
onready var empty_color_sign = $EmptyColorSign

func clear_color():
	self_modulate = Color.white
	$ColorPickerButton.visible = true
	empty_color = true
	
func set_color(color):
	self_modulate = color
	$ColorPickerButton.visible = false
	empty_color = false
	if color == Color.black:
		current_color_sign.modulate = Color.white
	else:
		current_color_sign.modulate = Color.black
	current_color_sign.modulate.a = 0.5

func _on_ColorButton_gui_input(event):
	if event is InputEventMouseButton:
		if !empty_color:
			StaticData.current_color = self_modulate
		else:
			NodeManager.get_color_picker_button().emit_signal("button_up")
		
			

func update_current_color_sign():
	if StaticData.current_color == self_modulate:
		current_color_sign.visible = true
	else:
		current_color_sign.visible = false
		
func update_none_sign():
	empty_color_sign.visible = empty_color
			
func _process(delta):
	update_current_color_sign()
	update_none_sign()
	


func _on_ColorPickerButton_popup_closed():
	StaticData.current_color = $ColorPickerButton.color
	set_color(StaticData.current_color)
