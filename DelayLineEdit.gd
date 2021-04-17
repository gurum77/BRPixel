extends LineEdit


func _process(delta):
	# 값이 유효한 경우에만 갱신한다.
	if is_valid_text():
		update_text()
	

func update_text():
	if text != str(StaticData.delay_per_frame):
		text = str(StaticData.delay_per_frame)
# text가 올바른 범위의 값인지?
func is_valid_text()->bool:
	var delay = text.to_float()
	if delay < Define.min_delay_per_frame:
		return false
	if delay > Define.max_delay_per_frame:
		return false
	return true
	
func _on_DelayLineEdit_text_changed(new_text):
	if !is_valid_text():
		return
	StaticData.delay_per_frame = text.to_float()

	# play 중이라면 다시 play해야 한다.(새로운 delay를 적용하기 위함) 
	if NodeManager.get_canvas().is_playing():
		NodeManager.get_canvas().play()
	


func _on_DelayLineEdit_gui_input(event):
	if InputManager.is_action_just_released_lbutton(event):
		select_all()
