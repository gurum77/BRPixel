extends Panel


# layer button을 업데이트한다.
func update_layer_button():
	var nodes = NodeManager.get_layers().get_children()
	for node in nodes:
		if not node is Layer:
			continue;
		
	
