extends Control

var palette_preview_resource = preload("res://Settings/PalettePreview.tscn")
var palettes = []
# Called when the node enters the scene tree for the first time.
func _ready():
	make_library_palettes()
	update_palette_previews()
	
func popup_centered():
	$DraggablePopup.popup_centered()
	
func update_palette_previews():
	var nodes = $DraggablePopup/ScrollContainer/VBoxContainer.get_children()
	for node in nodes:
		node.call_deferred("queue_free")
	for p in palettes:
		var ins = palette_preview_resource.instance()
		ins.palette = p
		$DraggablePopup/ScrollContainer/VBoxContainer.add_child(ins)
		
# library용 palettes들
func make_library_palettes():
	var dir = Directory.new()
	if dir.open("res://Assets/palettes/") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				file_name = dir.get_next()
				continue
			if file_name.get_extension() != "png":
				file_name = dir.get_next()
				continue
			
			var file_path = Util.get_file_path(dir.get_current_dir(), file_name)
			var image:Image = Image.new()
			image.load(file_path)
			
			
			var new_palette = Palette.new()
			new_palette.name = file_name.get_basename()
			new_palette.set_palette_from_image(image)
			new_palette.default_colors = false
			palettes.append(new_palette)
			file_name = dir.get_next()
	
