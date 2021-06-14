extends TextureButton
class_name UserBrushButton

var user_brush

# Called when the node enters the scene tree for the first time.
func _ready():
	if user_brush != null && user_brush.image != null:
		get_node("TextureRect").texture = Util.create_texture_from_image(user_brush.image)



func _on_UserBrushButton_pressed():
	StaticData.brush_type = StaticData.BrushType.User
	StaticData.set_current_user_brush(user_brush)
