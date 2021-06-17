extends Button

func _ready():
	Util.set_tooltip(self, tr("Move to last frame"), "End")
	
func _on_EndButton_pressed():
	run()
	
func run():
	NodeManager.get_canvas().stop()
	StaticData.current_frame_index = NodeManager.get_frames().get_frame_count()-1
