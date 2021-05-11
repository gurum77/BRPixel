extends Control
class_name MessageBox

enum Result{yes, no, ok, cancel}
var result = Result.cancel
var message:String = "no message"
var enabled_yes_button = true
var enabled_no_button = true
var enabled_ok_button = false
var wait_sec = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func update_controls():
	$DraggableWindow/VBoxContainer/MessageLabel.text = message
	
	$DraggableWindow/VBoxContainer/HBoxContainer/YesButton.visible = enabled_yes_button
	$DraggableWindow/VBoxContainer/HBoxContainer/NoButton.visible = enabled_no_button
	$DraggableWindow/VBoxContainer/HBoxContainer/OkButton.visible = enabled_ok_button
	

func popup_centered():
	$Tween.stop_all()
	modulate = Color.white
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
	
	# 크기 조절
	$DraggableWindow.rect_size.x = $DraggableWindow/VBoxContainer.rect_size.x + 20
	$DraggableWindow.rect_size.y = $DraggableWindow/VBoxContainer.rect_size.y + 20
		
	if wait_sec > -1:
		$Timer.start(wait_sec)

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


func _on_Timer_timeout():
	# 자동으로 사라질때는 서서히 사라지게 한다.
	$Tween.interpolate_property(self, "modulate", Color.white, Color.transparent, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()


func _on_Tween_tween_completed(_object, _key):
	hide()
