extends Pencil

func _ready():
	current_tool = StaticData.Tool.darker
	._ready()
	
func drawing_area_input(_event):
	.drawing_area_input(_event)
	
func set_pixels(points, _draw_on_preview_layer:bool=true):
	NodeManager.get_current_layer().set_pixels_by_darker(points)
