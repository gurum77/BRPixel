extends Control


func _ready():
	$Camera.zoom_fit()
	$Palettes/Palette.make_default_palette()
	$UI/ColorPanel.load_current_palette()
	

