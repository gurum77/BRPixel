extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# project name은 번역하면 안됨
	$DraggablePopup/HBoxContainer/ProjectNameLabel.set_message_translation(false)
	# 포커스는 클릭할 때만 들어가게 해야함
	$DraggablePopup/HBoxContainer/ProjectNameLabel.focus_mode = Control.FOCUS_CLICK

	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func hide():
	$DraggablePopup.hide()
	
func popup_centered():
	$DraggablePopup.popup_centered()
	update_controls()
	
func update_controls():
	$DraggablePopup/HBoxContainer/ProjectNameLabel.text = StaticData.project_name
	
# canvas size button
func _on_CanvasSizeButton_pressed():
	$DraggablePopup/GridContainer/CanvasSizeButton/CanvasSizePopup.popup_centered()


# new button
func _on_NewButton_pressed():
	$DraggablePopup/GridContainer/NewButton/NewPopup.popup_centered()


# language button
func _on_LanguageButton_pressed():
	$DraggablePopup/GridContainer/LanguageButton/LanguagePopup.popup_centered()

# 프로젝트 이름 변경
func _on_ProjectNameLabel_text_changed(new_text):
	StaticData.project_name = new_text


func _on_ProjectNameLabel_focus_entered():
	$DraggablePopup/HBoxContainer/ProjectNameLabel.editable = true


func _on_ProjectNameLabel_focus_exited():
	$DraggablePopup/HBoxContainer/ProjectNameLabel.editable = false
