extends Control
class_name UserBrushes

var user_brush = preload("res://Tools/UserBrush.tscn")

func _ready():
	# palettes는 크기가 있으면 안됨(다른 control에 메세지가 안감)
	rect_size = Vector2(0, 0)

func add_user_brush(var image):
	var new_user_brush = user_brush.instance()
	new_user_brush.image = image
	add_child(new_user_brush)

func get_user_brush_count():
	return get_child_count()
