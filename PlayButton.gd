extends Button


func _ready():
	Util.set_tooltip(self, tr("Play animation"), "Enter")
	
func update_texture():
	$PlayTexture.visible = !pressed
	$PauseTexture.visible = pressed

func _process(_delta):
	if pressed != NodeManager.get_canvas().is_playing():
		pressed = NodeManager.get_canvas().is_playing()
		update_texture()
	
func _on_PlayButton_pressed():
	run()
	
func run():
	if pressed:
		NodeManager.get_canvas().play()
	else:
		NodeManager.get_canvas().stop()
	update_texture()
		
