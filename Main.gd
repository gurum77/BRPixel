extends Control


func _ready():
	$Camera.zoom_fit()
	$UI/ColorPanel.load_current_palette()
	$UI/EditPanel/GridContainer/PencilButton.run()
	$UI/Preview.show()
	
	# 마지막 작업 로드
	load_last_project()

func load_last_project():
	if StaticData.open_auto_saved_project():
		Util.show_message(self, "Hello", "The last project was recovered.")
	pass
