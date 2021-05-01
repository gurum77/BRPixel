extends TextureRect

var empty_color = true
onready var current_color_sign = $CurrentColorSign
onready var setting_button = $SettingButton
onready var empty_color_sign = $EmptyColorSign
onready var transparent_color_sign = $TransparentColorSign

var pressed_position

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
	transparent_color_sign.visible = color.a == 0
		
	current_color_sign.modulate.a = 0.5
	
	# 실 데이타도 변경한다.
	var palette = NodeManager.get_current_palette()
	if palette != null:
		palette.set_color(get_index(), color)

func _on_ColorButton_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_DOWN || event.button_index == BUTTON_WHEEL_UP:
			return
			
		if event.pressed:
			pressed_position = get_global_mouse_position()
		else:
			# drag 상황이 아닐때만 색을 선택한
			if pressed_position.distance_squared_to(get_global_mouse_position()) < 3:
				if !empty_color:
					StaticData.current_color = self_modulate
				else:
					NodeManager.get_color_picker_button().emit_signal("button_up")
			pressed_position = null
		
			

func update_current_color_sign():
	if StaticData.current_color == self_modulate:
		current_color_sign.visible = true
		setting_button.visible = true
	else:
		current_color_sign.visible = false
		setting_button.visible = false
		
func update_none_sign():
	empty_color_sign.visible = empty_color
			
func _process(_delta):
	update_current_color_sign()
	update_none_sign()
	


func _on_ColorPickerButton_popup_closed():
	StaticData.current_color = $ColorPickerButton.color
	set_color(StaticData.current_color)
	NodeManager.get_color_panel().load_current_palette()


func _on_SettingButton_pressed():
	NodeManager.get_color_setting_popup().color_index = get_index()
	NodeManager.get_color_setting_popup().popup_centered()
