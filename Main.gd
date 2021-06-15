extends Control

func on_size_changed():
	if NodeManager.file_dialog != null:
		NodeManager.file_dialog.resize()
	

# 모든 윈도우 drive를 한번씩 오픈한다.



func _ready():
	# android가 아닐때는 stretch mode를 disable로 해야 함(아이콘 크기를 유지)
	if OS.get_name() != "Android":
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_EXPAND, Vector2(1280, 800), 1)
		NodeManager.get_layer_panel().rect_position.x += 300
		NodeManager.get_frame_panel().get_parent().get_parent().rect_position.y += 200
	else:
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_EXPAND, Vector2(800, 600), 1)
	
	Util.init_valid_drives()
	$Camera.zoom_fit()
	$UI/ColorPanel.load_current_palette()
	$UI/EditPanel/ScrollContainer/GridContainer/PencilButton.run()
	$UI/Preview.show()
	var _result = get_tree().root.connect("size_changed", self, "on_size_changed")
	
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
		Util.show_message(self, "Hello", "The last project was recovered.", 0.5)
	pass


func _on_Main_resized():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("copy"):
		if StaticData.enabled_selected_area():
			NodeManager.get_copy_button().on_CopyButton_pressed()
	elif event.is_action_pressed("cut"):
		if StaticData.enabled_selected_area():
			NodeManager.get_cut_button().on_CopyButton_pressed()
	elif event.is_action_pressed("paste"):
		var first_clipboard = NodeManager.get_copy_button().get_first_clipboard()
		if first_clipboard != null:
			first_clipboard.on_ClipBoardButton_pressed()
	elif event.is_action_pressed("undo"):
		NodeManager.get_undo_button().on_UndoButton_pressed()
	elif event.is_action_pressed("redo"):
		NodeManager.get_redo_button().on_RedoButton_pressed()
	elif event.is_action_pressed("select_all"):
		Util.run_edit_mode(Vector2(0, 0), StaticData.canvas_width, StaticData.canvas_height, false)
	elif event.is_action_pressed("delete"):
		NodeManager.get_clear_button().run()
	elif event.is_action_pressed("add_brush"):
		NodeManager.get_add_brush_button().run()
	elif event.is_action_pressed("pencil"):
		NodeManager.get_pencil_button().run()
	elif event.is_action_pressed("line"):
		NodeManager.get_line_button().run()
	elif event.is_action_pressed("fill_rectangle"):
		NodeManager.get_fill_rectangle_button().run()
	elif event.is_action_pressed("rectangle"):
		NodeManager.get_rectangle_button().run()
	elif event.is_action_pressed("fill_circle"):
		NodeManager.get_fill_circle_button().run()
	elif event.is_action_pressed("circle"):
		NodeManager.get_circle_button().run()
	elif event.is_action_pressed("eraser"):
		NodeManager.get_eraser_button().run()
	elif event.is_action_pressed("fill"):
		NodeManager.get_fill_button().run()
	elif event.is_action_pressed("select"):
		NodeManager.get_select_button().run()
	elif event.is_action_pressed("pick_color_from_canvas"):
		NodeManager.get_pick_color_from_canvas_button().run()
	elif event.is_action_pressed("move"):
		NodeManager.get_move_button().run()
	elif event.is_action_pressed("brighter"):
		NodeManager.get_brighter_button().run()
	elif event.is_action_pressed("darker"):
		NodeManager.get_darker_button().run()
	




