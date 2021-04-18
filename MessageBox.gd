extends Control
class_name MessageBox

enum Result{yes, no, ok, cancel}
var result = Result.cancel
var message:String = "no message"
var enabled_yes_button = true
var enabled_no_button = true
var enabled_ok_button = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func update_controls():
	$DraggableWindow/VBoxContainer/MessageLabel.text = message
	
	$DraggableWindow/VBoxContainer/HBoxContainer/YesButton.visible = enabled_yes_button
	$DraggableWindow/VBoxContainer/HBoxContainer/NoButton.visible = enabled_no_button
	$DraggableWindow/VBoxContainer/HBoxContainer/OkButton.visible = enabled_ok_button
	

func popup_centered():
	# background를 가득 채운다.
	var width = ProjectSettings.get("display/window/size/width")
	var height = ProjectSettings.get("display/window/size/height")
	$BackgroundPanel.rect_global_position.x = 0
	$BackgroundPanel.rect_global_position.y = 0
	$BackgroundPanel.rect_size.x = width
	$BackgroundPanel.rect_size.y = height
	
	update_controls()
	show()
	$DraggableWindow.popup_centered()


func _on_YesButton_pressed():
	result = Result.yes
	$DraggableWindow.hide()
	hide()


func _on_NoButton_pressed():
	result = Result.no
	$DraggableWindow.hide()
	hide()


func _on_OkButton_pressed():
	result = Result.ok
	$DraggableWindow.hide()
	hide()
