extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# grips는 크기가 있으면 안됨(다른 control에 메세지가 안감)
	rect_size = Vector2(0, 0)

func on_camera_zoomed():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
