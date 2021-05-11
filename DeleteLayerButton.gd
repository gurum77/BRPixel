extends Button


var message_box
func _on_DeleteLayerButton_pressed():
	var layers = NodeManager.get_current_layers()
	if layers == null:
		return
		
	# layer가 하나밖에 없으면 삭제 불가
	if layers.get_child_count() == 1:
		return
	message_box = Util.show_yesno_message_box(tr("Do you really delete the current layer?") + "\n" + tr("This operation cannot be undone."))
	message_box.connect("hide", self, "on_MessageBox_hide")
func _process(_delta):
	var layers = NodeManager.get_current_layers()
	if layers != null:
		disabled = layers.get_child_count() == 1
	
func on_MessageBox_hide():
	message_box.disconnect("hide", self, "on_MessageBox_hide")
	if message_box.result != MessageBox.Result.yes:
		return
		
	# 현재 layer를 지우고 다음 layer를 현재 layer로 설정한다.
	var frame = NodeManager.get_frame(StaticData.current_frame_index)
	if(frame == null):
		return
	frame.get_layers().remove_layer(StaticData.current_layer_index)
	
	# layer button을 재생성 한다.
	NodeManager.get_layer_panel().regen_layer_buttons()

