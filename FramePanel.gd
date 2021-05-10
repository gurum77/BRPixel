extends Panel
class_name FramePanel

var frame_button_node = preload("res://Canvas/FrameButton.tscn")
var add_frame_button_on_frame_panel = preload("res://ToolButtons/AddFrameButtonOnFramePanel.tscn")
onready var frame_button_parent = $VBoxContainer/ScrollContainer/HBoxContainer

# frame button을 다시 만들지는 않고 갱신만 한다.
# 설정등이 변경 되었을때 호
func update_frame_buttons():
	var nodes = frame_button_parent.get_children()
	for node in nodes:
		if node is AddFrameButtonOnFramePanel:
			continue
		node.update()
		node.update_frame_preview()
		
# frame button을 다시 만든다.
func regen_frame_buttons():
	# 기존 frame panel에 있는 frame 버튼을 제거
	var nodes = frame_button_parent.get_children()
	for node in nodes:
		node.queue_free()
		
	# frame 버튼을 새로 만든다.
	var frames = NodeManager.get_frames().get_children()
	for node in frames:
		if not node is Frame:
			continue
		if node.unused:
			continue
			
		var frame_button = frame_button_node.instance()
		frame_button_parent.add_child(frame_button)
		frame_button.update_frame_preview(node as Frame)
	
	# frame 추가 버튼을 마지막에 만든다.
	var add_frame_button_ins = add_frame_button_on_frame_panel.instance()
	frame_button_parent.add_child(add_frame_button_ins)
