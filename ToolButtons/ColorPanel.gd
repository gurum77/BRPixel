extends Panel
class_name ColorPanel
onready var palette_num_label = $VBoxContainer/HBoxContainer3/NumLabel
onready var buttons_parent = $ScrollContainer/GridContainer
onready var sort_button = $VBoxContainer/HBoxContainer/SortButton
var color_button_node = preload("res://ToolButtons/ColorButton.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# color button을 필요한 만큼 만든다.
func make_color_buttons():
	var palette:Palette = NodeManager.get_current_palette()
	var button_count = buttons_parent.get_child_count()
	var need_count = (palette.colors.size()+1)
	if need_count > button_count:
		var diff = need_count - button_count
		for i in diff:
			buttons_parent.add_child(color_button_node.instance())
	elif need_count < button_count:
		var diff = button_count - need_count
		for i in diff:
			buttons_parent.remove_child(buttons_parent.get_child(0))

# 현재 색상이 있다면 scroll을 한다.
func scroll_color_buttons_to_current_color():
	var sbar = $ScrollContainer.get_v_scrollbar() as ScrollBar
	var min_value = sbar.min_value
	var max_value = sbar.max_value
	var current_color_index = 0
	var palette:Palette = NodeManager.get_current_palette()
	if palette != null && palette.colors.has(StaticData.current_color):
		for i in palette.colors.size():
			if palette.colors[i] == StaticData.current_color:
				$ScrollContainer.scroll_vertical = (max_value - min_value) / ((i + 1) / palette.colors.size())
				
		
	
	
func load_current_palette():
	$ScrollContainer/GridContainer.columns = 100 / StaticData.palette_size
	# color button을 필요한 만큼 만든다.
	make_color_buttons()
	update_sort_button_text()
	
	# button의 크기와 색을 설정한다.
	var index = 0
	var buttons = buttons_parent.get_children()
	for button in buttons:
		button.rect_min_size.x = StaticData.palette_size
		button.rect_min_size.y = StaticData.palette_size
		button.rect_size.x = StaticData.palette_size
		button.rect_size.y = StaticData.palette_size
		update_color_button(index)
		index += 1
	
			
func update_color_button(color_index:int):
	var button = buttons_parent.get_child(color_index)
	if button == null:
		return
		
	var palette:Palette = NodeManager.get_current_palette()
	if palette != null && palette.colors.size() > color_index:
		button.set_color(palette.colors[color_index])
	else:
		button.clear_color()

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
	NodeManager.get_current_palette().sort()
	load_current_palette()
	
# 현재 palette의 sort 상태를 표시한다.
func update_sort_button_text():
	var text = ""
	var palette:Palette = NodeManager.get_current_palette()
	if palette.current_sort_type == Palette.sort_type.red:
		text = "R"
	elif palette.current_sort_type == Palette.sort_type.green:
		text = "G"
	elif palette.current_sort_type == Palette.sort_type.blue:
		text = "B"
	elif palette.current_sort_type == Palette.sort_type.hue:
		text = "H"
	elif palette.current_sort_type == Palette.sort_type.alpha:
		text = "A"
		
	sort_button.text = text
	
