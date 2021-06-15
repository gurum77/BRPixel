extends ItemList


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_item("Pattern aligned to source")
	add_item("Pattern aligned to destination")
	add_item("Paint brush")
	select(StaticData.user_brush_pattern as int)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
