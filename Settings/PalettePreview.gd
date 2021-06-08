extends Control
class_name PalettePreview

var palette:Palette
var color_rect_size = 15
func _ready():
	update_preview()
	update_grid_column_nums()
	
func update_grid_column_nums():
	var hsep = $GridContainer.get("custom_constants/hseparation")
	var gap = 4
	if hsep != null:
		gap = hsep
	$GridContainer.columns = $GridContainer.rect_size.x / (color_rect_size + gap)
	
	
func update_preview():
	if palette == null:
		return
	$NameButton.set_text(palette.name)
	var nodes = $GridContainer.get_children()
	for node in nodes:
		node.call_deferred("queue_free")
	for col in palette.colors:
		var color_rect = ColorRect.new()
		color_rect.color = col
		
		color_rect.rect_min_size.x = color_rect_size
		color_rect.rect_min_size.y = color_rect_size
		color_rect.rect_size.x = color_rect.rect_min_size.x
		color_rect.rect_size.y = color_rect.rect_min_size.y
		$GridContainer.add_child(color_rect)


func _on_NameButton_pressed():
	# 이미 있으면 선택해준다.
	var nodes = NodeManager.get_palettes().get_children()
	for i in nodes.size():
		if nodes[i].name == palette.name:
			StaticData.current_palette_index = i
			NodeManager.get_color_panel().load_current_palette()
			return
			
	# 없으면 추가한다.
	NodeManager.get_palettes().add_child(palette)
	StaticData.current_palette_index = NodeManager.get_palettes().get_child_count()-1
	NodeManager.get_color_panel().load_current_palette()
	
