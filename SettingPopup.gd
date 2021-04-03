extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func hide():
	$DraggablePopup.hide()
	
func popup_centered():
	$DraggablePopup.popup_centered()
	
# canvas size button
func _on_CanvasSizeButton_pressed():
	$DraggablePopup/GridContainer/CanvasSizeButton/CanvasSizePopup.popup_centered()


# new button
func _on_NewButton_pressed():
	$DraggablePopup/GridContainer/NewButton/NewPopup.popup_centered()
