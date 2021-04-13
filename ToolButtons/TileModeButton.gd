extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TileModeButton_pressed():
	StaticData.enabled_tilemode = !StaticData.enabled_tilemode
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
	
	
	
	
