extends Control
class_name Palettes

var palette = preload("res://Tools/Palette.tscn")

func get_palette(index)->Palette:
	return get_child(index) as Palette
func clear_palettes():
	var nodes = get_children()
	for node in nodes:
		node.call_deferred("queue_free")
		
func get_palette_count()->int:
	return get_child_count()

func add_palette()->Palette:
	var ins = palette.instance()
	add_child(ins)
	return ins
	
	
