extends Pencil
class_name EraserTool

func _ready():
	current_tool = StaticData.Tool.eraser
	._ready()

func drawing_area_input(_event):
	.drawing_area_input(_event)
	
func set_pixel_with_colors(pixels:Dictionary):
	NodeManager.get_current_layer().erase_pixels(pixels.keys())
		
