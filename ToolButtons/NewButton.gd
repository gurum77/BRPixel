extends TextureRectButton
class_name NewButton

func _ready():
	Util.set_tooltip(self, tr("New project"), "Ctrl+N")
	
func _on_NewButton_pressed():
	run()
	
func run():
	$NewPopup.popup_centered()


func _on_NewButton_gui_input(event):
	run_gui_input(event)
