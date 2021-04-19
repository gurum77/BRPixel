extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# project name은 번역하면 안됨
	$DraggablePopup/HBoxContainer/ProjectNameLabel.set_message_translation(false)

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
