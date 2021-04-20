extends Control


func _ready():
	$Camera.zoom_fit()
	$UI/ColorPanel.load_current_palette()
	$UI/EditPanel/GridContainer/PencilButton.run()
