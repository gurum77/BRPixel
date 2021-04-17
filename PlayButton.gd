extends Button


func update_texture():
	$PlayTexture.visible = !pressed
	$PauseTexture.visible = pressed

func _process(delta):
	if pressed != NodeManager.get_canvas().is_playing():
		pressed = NodeManager.get_canvas().is_playing()
		update_texture()
	
func _on_PlayButton_pressed():
	if pressed:
		NodeManager.get_canvas().play()
	else:
		NodeManager.get_canvas().stop()
	update_texture()
		
