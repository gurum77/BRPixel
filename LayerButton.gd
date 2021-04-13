extends TextureRect

var layer_index = 0
func _ready():
	update()
	update_layer()
	
func update_layer():
	var layer= get_layer()
	if layer == null:
		return
	$Layer.image = layer.image
	$Layer.modulate.a = layer.modulate.a
	$Layer.update_texture()
	

func is_current_layer()->bool:
	if StaticData.current_layer == null:
		return false
		
	if StaticData.current_layer.index == layer_index:
		return true
	return false

func _on_Timer_timeout():
	if is_current_layer():
		update_layer()

func get_layer()->Layer:
	return NodeManager.get_layers().get_layer(layer_index)
	
func update():
	if get_layer().visible:
		modulate = Color.white
	else:
		modulate = Color.darkgray
	$CurrentLayerSign.visible = is_current_layer()


func _on_LayerButton_gui_input(event):
	# L 버튼 클릭시 현재 layer로 설정
	if InputManager.is_action_just_pressed_lbutton(event):
		StaticData.current_layer = get_layer()
		NodeManager.get_layer_panel().update_layer_buttons()
	elif InputManager.is_action_just_pressed_rbutton(event):
		get_layer().toggle_visible()
		update()
			

func _on_SettingButton_pressed():
	$SettingButton/LayerSettingPopup.selected_layer = get_layer()
	$SettingButton/LayerSettingPopup.popup_centered()
