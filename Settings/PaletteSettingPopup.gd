extends Control

var palette_resource = preload("res://Tools/Palette.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func popup_centered():
	$DraggablePopup.popup_centered()

func hide():
	$DraggablePopup.hide()
	
func _on_NewPaletteButton_pressed():
	var new_palette = palette_resource.instance()
	new_palette.default_colors = false
	NodeManager.get_palettes().add_child(new_palette)
	StaticData.current_palette_index = NodeManager.get_palettes().get_palette_count()-1
	NodeManager.get_color_panel().load_current_palette()
	hide()
