extends Pencil

func _ready():
	current_tool = StaticData.Tool.brighter
	._ready()
	
func _input(_event):
	._input(_event)

func set_pixels(points):
	StaticData.current_layer.set_pixels_by_brighter(points)
