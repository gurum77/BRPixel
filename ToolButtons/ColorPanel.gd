extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func load_current_palette():
	var buttons = $ScrollContainer/GridContainer.get_children()
	var palette:Palette = StaticData.current_palette
	for i in range(0, buttons.size()):
		if palette != null && palette.colors.size() > i:
			buttons[i].modulate = palette.colors[i]
		else:
			buttons[i].modulate = Color.white
			
