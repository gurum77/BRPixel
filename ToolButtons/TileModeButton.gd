extends TextureRectButton

func _ready():
	Util.set_tooltip(self, tr("Tilemode on/off"), "")

func _process(_delta):
	pressed = StaticData.enabled_tilemode
	
func _on_TileModeButton_pressed():
	run()

func run():
	StaticData.enabled_tilemode = pressed
	# tile mode manager 초기화
	var tile_mode_manager:TileModeManager = NodeManager.get_tile_mode_manager()
	tile_mode_manager.init_tile_layers()
	tile_mode_manager.visible = StaticData.enabled_tilemode
	tile_mode_manager.update_force()
	
	# canvas 다시 그린다.
	NodeManager.get_canvas().resize()
	NodeManager.get_canvas().update()
	
	# 마지막 drawing tool을 실행한다.
	NodeManager.get_tools().run_last_drawing_tool()
	
	# symmetry 그립 갱신
	NodeManager.get_symmetry_grips().update_canvas_and_grips()
	
	# save backup
	StaticData.save_auto_saved_project()
	

func _on_TileModeButton_gui_input(event):
	run_gui_input(event)
