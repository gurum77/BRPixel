extends WindowDialog
class_name Preview
onready var texture_rect = $TextureRect
func _ready():
	texture_rect.texture = ImageTexture.new()
	texture_rect.texture.flags = 0
	
func _draw():
	if NodeManager.get_current_layers() == null:
		return
		
	var image = NodeManager.get_current_layers().create_layers_image(Color.white)
	texture_rect.texture.create_from_image(image)
	if image.get_width() > rect_size.x || image.get_height() > rect_size.y:
		texture_rect.expand = true
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	else:
		texture_rect.expand = false
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
	pass

func _on_Timer_timeout():
	update()


func _on_Preview_mouse_entered():
	StaticData.mouse_inside_ui = true


func _on_Preview_mouse_exited():
	StaticData.mouse_inside_ui = false
