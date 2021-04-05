extends Button

export var add_image = false

func _on_OpenFileDialog_file_selected(path):
		
	if add_image:
		# 파일을 image로 로딩
		var image:Image = Util.load_image_file(self, path)
		if image == null:
			return
		
		Util.AttachImageWithEditTool(image, Vector2(0, 0))
	else:
		var ext = $OpenFileDialog.current_file.get_extension()
		if ext == "pex":
			StaticData.open_project(path)


func _on_OpenButton_pressed():
	if add_image:
		$OpenFileDialog.filters = PoolStringArray(["*.png;PNG", "*.jpg;JPEG"])
	else:
		$OpenFileDialog.filters = PoolStringArray(["*.pex;Pixel Express"])

	$OpenFileDialog.popup_centered()
	$OpenFileDialog.show()

