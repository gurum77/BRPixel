extends Button

func _on_ShareSelectedAreaButton_pressed():
	var godot_share = PluginManager.get_godot_share()
	if godot_share != null:
		var image_save_path = OS.get_user_data_dir() + "/brpixel_share_image_____.png"
		var error = StaticData.save_image(image_save_path, true, true)
		if error == OK:
			godot_share.sharePic(image_save_path, "BRPixel", StaticData.project_name, "This amazing image is made by BRPixel.")
		else:
			Util.show_error_message(self, error)
	else:
		Util.show_android_only_message(self)

func _process(_delta):
	disabled = !StaticData.enabled_selected_area()
