extends PopupDialog
class_name DraggablePopup


var drag_position = null
var queue_free_on_hide = false	# hide할때 삭제할것.

func _on_DraggablePopup_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			drag_position = get_global_mouse_position() - rect_global_position
		else:
			drag_position = null
	if event is InputEventMouseMotion and drag_position:
		rect_global_position = get_global_mouse_position() - drag_position


func _on_CloseButton_pressed():
	hide()

func _on_MessagePopup_popup_hide():
	if queue_free_on_hide:
		call_deferred("queue_free")
