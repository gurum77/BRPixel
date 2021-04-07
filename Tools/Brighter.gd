extends Pencil

func _ready():
	current_tool = StaticData.Tool.brighter
	._ready()
	
func _input(_event):
	._input(_event)
