extends Pencil
class_name BrighterTool

func _ready():
	current_tool = StaticData.Tool.brighter
	._ready()
	
func drawing_area_input(_event):
	.drawing_area_input(_event)

func set_pixel_with_colors(pixels:Dictionary):
	NodeManager.get_current_layer().set_pixels_by_brighter(pixels.keys())
