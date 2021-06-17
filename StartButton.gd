extends Button

func _ready():
	Util.set_tooltip(self, tr("Move to first frame"), "Home")

func _on_StartButton_pressed():
	run()
	
func run():
	NodeManager.get_canvas().stop()
	StaticData.current_frame_index = 0
	
