extends Label

func _process(_delta):
	var layer_count = 1
	var layers = NodeManager.get_current_layers()
	if layers != null:
		layer_count = layers.get_normal_layers().size()
	text = "%d / %d %s" % [StaticData.current_layer_index+1, layer_count, tr("Layer")]
