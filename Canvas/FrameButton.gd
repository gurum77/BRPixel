extends TextureRect


func _process(_delta):
	update()

func update():
	$CurrentFrameSign.visible = is_current_frame()
	
func is_current_frame()->bool:
	if StaticData.current_frame_index == get_index():
		return true
	return false
	
func _on_FrameButton_gui_input(event):
	# L 버튼 클릭시 현재 frame으로 설정
	if InputManager.is_action_just_pressed_lbutton(event):
		StaticData.current_frame_index = get_index()
		# 모든 layer button을 갱신한다.(layer button은 현재 layer만 갱신하므로 여기서 한번 모두 갱신해줘야 한다)
		NodeManager.get_layer_panel().update_layer_buttons()

func get_frame()->Frame:
	return NodeManager.get_frames().get_frame(get_index())
	
func update_frame_preview(frame:Frame=null):
	if frame == null:
		frame = get_frame()
	if frame == null:
		return
		
	var layers = frame.get_layers()
	if layers == null:
		return
	$Layer.image = layers.create_layers_image()
	$Layer.update_texture()

func _on_Timer_timeout():
	if is_current_frame():
		update_frame_preview()


func _on_SettingButton_pressed():
	$SettingButton/FrameSettingPopup.selected_frame = get_frame()
	$SettingButton/FrameSettingPopup.popup_centered()
