extends Panel
class_name ColorPanel
onready var palette_num_label = $VBoxContainer/HBoxContainer/NumLabel
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func load_current_palette():
	var buttons = $ScrollContainer/GridContainer.get_children()
	var palette:Palette = NodeManager.get_current_palette()
	$ScrollContainer/GridContainer.columns = 100 / StaticData.palette_size
	for i in range(0, buttons.size()):
		
		buttons[i].rect_min_size.x = StaticData.palette_size
		buttons[i].rect_min_size.y = StaticData.palette_size
		buttons[i].rect_size.x = StaticData.palette_size
		buttons[i].rect_size.y = StaticData.palette_size
		
		if palette != null && palette.colors.size() > i:
			buttons[i].set_color(palette.colors[i])
		else:
			buttons[i].clear_color()
			

func _on_PrevButton_pressed():
	StaticData.current_palette_index -= 1
	if StaticData.current_palette_index < 0:
		StaticData.current_palette_index = NodeManager.get_palettes().get_palette_count() - 1
	load_current_palette()
		


func _on_NextButton_pressed():
	StaticData.current_palette_index += 1
	if StaticData.current_palette_index >= NodeManager.get_palettes().get_palette_count():
		StaticData.current_palette_index = 0
	load_current_palette()


func _on_SortButton_pressed():
	pass # Replace with function body.
