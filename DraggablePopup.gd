extends PopupDialog
class_name DraggablePopup


var drag_position = null
var queue_free_on_hide = false	# hide할때 삭제할것.
#var popup_exclusive_old = false
func _ready():
	pass
	# 마우스를 뗄때 닫도록 제어하기 위해 popup_exclusive를 true로 한다.
#	popup_exclusive_old = popup_exclusive
#	popup_exclusive = true
	
#func _input(event):
#
#	# 마우스를 떼면 닫을지 체크한다.
#	if !popup_exclusive_old && visible:
#		if InputManager.is_action_just_released_lbutton(event) && !_is_pos_in(event.position):
#			hide()
#			return
#	# popup_exclusive와 상관없이 esc를 누르면 닫는다.
#	if visible && event.is_action_pressed("ui_cancel"):
#		hide()
#		return
		
func _on_DraggablePopup_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			drag_position = get_global_mouse_position() - rect_global_position
		else:
			drag_position = null
	if event is InputEventMouseMotion and drag_position:
		rect_global_position = get_global_mouse_position() - drag_position

func _is_pos_in(checkpos:Vector2):
	var gr = get_global_rect()
	return checkpos.x>=gr.position.x and checkpos.y>=gr.position.y and 	checkpos.x<gr.end.x and checkpos.y<gr.end.y
	
func _on_CloseButton_pressed():
	hide()

func _on_MessagePopup_popup_hide():
	if queue_free_on_hide:
		call_deferred("queue_free")




func _on_DraggablePopup_visibility_changed():
	if !visible:
		InputManager.ignore_first_button_up = true
		InputManager.remove_showing_popup(self)
	else:
		InputManager.add_showing_popups(self)
