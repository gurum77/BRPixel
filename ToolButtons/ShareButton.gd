extends TextureRectButton
class_name ShareButton

func _ready():
	Util.set_tooltip(self, tr("Share"), "Ctrl+H")
	
func _on_ShareButton_pressed():
	run()
	
func run():
	var godot_share = PluginManager.get_godot_share()
	if godot_share != null:
		var image_save_path = OS.get_user_data_dir() + "/brpixel_share_image_____.png"
		var error = StaticData.save_image(image_save_path, false, true)
		if error == OK:
			godot_share.sharePic(image_save_path, "BRPixel", StaticData.project_name, "This amazing image is made by BRPixel.")
		else:
			Util.show_error_message(self, error)
	else:
		Util.show_android_only_message(self)


func _on_ShareButton_gui_input(event):
	run_gui_input(event)
