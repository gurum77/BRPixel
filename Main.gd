extends Control


func _ready():
	$Camera.zoom_fit()
	$UI/ColorPanel.load_current_palette()
	$UI/EditPanel/GridContainer/PencilButton.run()
	$UI/Preview.show()
	
	# test
#
#	var colors = []
#	var image = Util.create_image(512, 512)
#	var start_time = OS.get_ticks_msec()
#	image.lock()
#	var width = image.get_width()
#	var height = image.get_height()
#	for x in width:
#		for y in height:
#			var c = image.get_pixel(x, y)
#			colors.append(c)
#			var idx = GeometryMaker.to_1D(x, y, width)
#			var v = GeometryMaker.to_2D(idx, width)
#	image.unlock()
#	var a = 0
#	var elapsed_time = OS.get_ticks_msec() - start_time
	
	# 마지막 작업 로드
	load_last_project()

func load_last_project():
	if StaticData.open_auto_saved_project():
		Util.show_message(self, "Hello", "The last project was recovered.", 1.5)
	pass
