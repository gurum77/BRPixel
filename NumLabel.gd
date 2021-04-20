extends Label

func _process(_delta):
	text = str(StaticData.current_palette_index+1) + " / " + str(NodeManager.get_palettes().get_palette_count())
