extends WindowDialog

func _ready():
	$TextureRect.texture = ImageTexture.new()
	$TextureRect.texture.flags = 0
	
func _draw():
	if NodeManager.get_current_layers() == null:
		return
		
	var image = NodeManager.get_current_layers().create_layers_image(Color.white)
	$TextureRect.texture.create_from_image(image)
	if image.get_width() > rect_size.x || image.get_height() > rect_size.y:
		$TextureRect.expand = true
		$TextureRect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	else:
		$TextureRect.expand = false
		$TextureRect.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		
		
	
	
	pass

func _on_Timer_timeout():
	update()


func _on_Preview_mouse_entered():
	StaticData.mouse_inside_ui = true


func _on_Preview_mouse_exited():
	StaticData.mouse_inside_ui = false
