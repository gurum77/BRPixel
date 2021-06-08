extends Control

var palette_preview_resource = preload("res://Settings/PalettePreview.tscn")
var palettes = []
var textures = [
			preload("res://Assets/palettes/aap-64-1x.png"),
			preload("res://Assets/palettes/cc-29-1x.png"),
			preload("res://Assets/palettes/endesga-32-1x.png"),
			preload("res://Assets/palettes/endesga-64-1x.png"),
			preload("res://Assets/palettes/famicube-1x.png"),
			preload("res://Assets/palettes/fantasy-24-1x.png"),
			preload("res://Assets/palettes/journey-1x.png"),
			preload("res://Assets/palettes/lospec500-1x.png"),
			preload("res://Assets/palettes/na16-1x.png"),
			preload("res://Assets/palettes/oil-6-1x.png"),
			preload("res://Assets/palettes/pear36-1x.png"),
			preload("res://Assets/palettes/pico-8-1x.png"),
			preload("res://Assets/palettes/resurrect-64-1x.png"),
			preload("res://Assets/palettes/slso8-1x.png"),
			preload("res://Assets/palettes/sweetie-16-1x.png"),
			preload("res://Assets/palettes/vinik24-1x.png"),
			preload("res://Assets/palettes/zughy-32-1x.png"),
			preload("res://Assets/palettes/comfort44s-1x.png"),
			preload("res://Assets/palettes/bubblegum-16-1x.png"),
			preload("res://Assets/palettes/pineapple-32-1x.png"),
			preload("res://Assets/palettes/ammo-8-1x.png"),
			preload("res://Assets/palettes/japanese-woodblock-1x.png"),
			preload("res://Assets/palettes/indecision-1x.png"),
			preload("res://Assets/palettes/sheltzy32-1x.png"),
			preload("res://Assets/palettes/pollen8-1x.png"),
			preload("res://Assets/palettes/blk-36-1x.png"),
			preload("res://Assets/palettes/srb2-1x.png"),
			preload("res://Assets/palettes/rustic-gb-1x.png"),
			preload("res://Assets/palettes/rosy-42-1x.png"),
			preload("res://Assets/palettes/resurrect-32-1x.png"),
			preload("res://Assets/palettes/1bit-monitor-glow-1x.png"),
			preload("res://Assets/palettes/mist-gb-1x.png"),
			preload("res://Assets/palettes/2-bit-grayscale-1x.png"),
			preload("res://Assets/palettes/31-1x.png"),
			preload("res://Assets/palettes/endesga-36-1x.png"),
			preload("res://Assets/palettes/blessing-1x.png"),
			preload("res://Assets/palettes/aap-splendor128-1x.png"),
			preload("res://Assets/palettes/island-joy-16-1x.png"),
			preload("res://Assets/palettes/blk-neo-1x.png"),
			preload("res://Assets/palettes/lux2k-1x.png"),
			preload("res://Assets/palettes/endesga-16-1x.png"),
			preload("res://Assets/palettes/aurora-1x.png"),
			preload("res://Assets/palettes/ice-cream-gb-1x.png"),
			preload("res://Assets/palettes/dawnbringer-32-1x.png"),
			preload("res://Assets/palettes/vines-flexible-linear-ramps-1x.png"),
			preload("res://Assets/palettes/fleja-master-palette-1x.png"),
			preload("res://Assets/palettes/nintendo-entertainment-system-1x.png"),
			preload("res://Assets/palettes/nyx8-1x.png"),
			preload("res://Assets/palettes/steam-lords-1x.png"),
			preload("res://Assets/palettes/apollo-1x.png"),
			preload("res://Assets/palettes/kirokaze-gameboy-1x.png")		
			]
			
			

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
#	var dir = Directory.new()
#	if dir.open("res://Assets/palettes/") == OK:
#		dir.list_dir_begin()
#		var file_name = dir.get_next()
#		while file_name != "":
#			if dir.current_is_dir():
#				file_name = dir.get_next()
#				continue
#			if file_name.get_extension() != "png":
#				file_name = dir.get_next()
#				continue
#
#			var file_path = Util.get_file_path(dir.get_current_dir(), file_name)
#			var texture = load(file_path)
#
#			var new_palette = Palette.new()
#			new_palette.name = file_name.get_basename()
#			new_palette.set_palette_from_image(texture.get_data())
#			new_palette.default_colors = false
#			palettes.append(new_palette)
#			file_name = dir.get_next()var dir = Directory.new()
#	if dir.open("res://Assets/palettes/") == OK:
#		dir.list_dir_begin()
#		var file_name = dir.get_next()
#		while file_name != "":
#			if dir.current_is_dir():
#				file_name = dir.get_next()
#				continue
#			if file_name.get_extension() != "png":
#				file_name = dir.get_next()
#				continue
#
#			var file_path = Util.get_file_path(dir.get_current_dir(), file_name)
#			var texture = load(file_path)
#
#			var new_palette = Palette.new()
#			new_palette.name = file_name.get_basename()
#			new_palette.set_palette_from_image(texture.get_data())
#			new_palette.default_colors = false
#			palettes.append(new_palette)
#			file_name = dir.get_next()
	
	for texture in textures:
		var new_palette = Palette.new()
		var path:String = texture.get("resource_path")
		new_palette.name = path.get_file()
		new_palette.name = new_palette.name.left(new_palette.name.length() - 6)
		new_palette.set_palette_from_image(texture.get_data())
		new_palette.default_colors = false
		palettes.append(new_palette)
		

# 검색
func _on_SearchingLineEdit_text_changed(new_text):
	var container = $DraggablePopup/ScrollContainer/VBoxContainer
	var nodes = container.get_children()
	for node in nodes:
		var pp = node as PalettePreview
		if new_text == "":
			pp.visible = true
			continue
			
		var find = pp.palette.name.find(new_text)
		if find < 0:
			pp.visible = false
		else:
			pp.visible = true
		


func _on_LinkButton_pressed():
	var _result = OS.shell_open("https://lospec.com/palette-list")

