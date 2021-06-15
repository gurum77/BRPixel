extends Pencil
class_name DarkerTool
func _ready():
	current_tool = StaticData.Tool.darker
	._ready()
	
func drawing_area_input(_event):
	.drawing_area_input(_event)
	
func set_pixel_with_colors(pixels:Dictionary):
	NodeManager.get_current_layer().set_pixels_by_darker(pixels.keys())
