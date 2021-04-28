extends Button
var clipboard_button = preload("res://ToolButtons/ClipBoardButton.tscn")

# cut 기능인지?
export var cut = false

# clipboard 갯수
func get_clipboard_count()->int:
	var nodes = get_parent().get_children()
	var clipboard_count = 0
	for node in nodes:
		if node is ClipBoardButton:
			clipboard_count += 1
	return clipboard_count
	
# 마지막 clipboard 리턴(가장 오래된 clipboard이다)
func get_last_clipboard()->ClipBoardButton:
	var nodes = get_parent().get_children()
	var clipboard:ClipBoardButton
	for node in nodes:
		if node is ClipBoardButton:
			clipboard = node as ClipBoardButton
	return clipboard
		
func move_clipboard_to_first_position(clipboard):
	var idx = 0
	var nodes = get_parent().get_children()
	for node in nodes:
		if node is ClipBoardButton:
			break
		idx += 1
	get_parent().move_child(clipboard, idx)
	
func _on_CopyButton_pressed():
	if !StaticData.enabled_selected_area():
		Util.show_message(self, "Clipboard", "No area is selected")
		return

	
	var image = Util.create_image_from_selected_area()
	
	# clip boards 노드에 추가
	var ins:Button = clipboard_button.instance()
	get_parent().add_child(ins)
	
	# clip board를 다른 clipboard 중 첫번째로 이동
	move_clipboard_to_first_position(ins)
	
	
	# clip board 버튼의 texturerect에 이미지를 설정
	ins.get_node("TextureRect").texture = Util.create_texture_from_image(image)
	ins.clipboard_position = StaticData.selected_area.position
	
	# 최대 clipboard 갯수를 초과했으면 가장 오래된 clipboard를 삭제
	var clipboard_count = get_clipboard_count()
	if clipboard_count > Define.max_clipboard_count:
		remove_oldest_clipboard()
	
	# 사이즈 조정
	get_parent().get_parent().get_parent().resize()
	
	# 선택했던 영역은 삭제를 한다.
	if cut:
		UndoManager.prepare_undo_for_draw_on_current_layer()
		NodeManager.get_current_layer().erase_pixels_by_rect(StaticData.selected_area)
		UndoManager.append_undo_for_draw_on_current_layer_by_Rect(StaticData.selected_area)
		UndoManager.commit_undo_for_draw_on_current_layer()

# 가장 오래된 clipboard를 삭제한다.
func remove_oldest_clipboard():
	var node = get_last_clipboard()
	if node != null:
		node.unused = true
		node.call_deferred("queue_free")
	
	
