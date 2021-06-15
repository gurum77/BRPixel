extends TextureButton
class_name BrushTypeButton

var last_drawn_thickness = 0
var user_brush_button = preload("res://ToolButtons/UserBrushButton.tscn")
func _ready():
	$GridContainer.visible = false
	
func _draw():
	var center_position = Vector2(rect_size.x / 2, rect_size.y / 2)
	if StaticData.brush_type != StaticData.BrushType.User:
		var pixels = GeometryMaker.get_pixels_by_thickness(center_position, StaticData.pencil_thickness)
		for pixel in pixels:
			draw_circle(pixel, 1, Color.black)
	else:
		draw_texture_rect(StaticData.current_user_brush_texture, Rect2(0, 0, rect_size.x, rect_size.y), false)
#	last_drawn_thickness = StaticData.pencil_thickness

func _process(_delta):
	if last_drawn_thickness != StaticData.pencil_thickness:
		update()


func _on_RectangleButton_pressed():
	$GridContainer.visible = false
	StaticData.brush_type = StaticData.BrushType.rectangle
	update()


func _on_CircleButton_pressed():
	$GridContainer.visible = false
	StaticData.brush_type = StaticData.BrushType.circle
	update()


func _on_BrushTypeButton_pressed():
	$GridContainer.visible = true

func update_user_brush_buttons():
	var nodes = $GridContainer.get_children()
	for node in nodes:
		if node is UserBrushButton:
			node.call_deferred("queue_free")

	nodes = NodeManager.get_user_brushes().get_children()
	for node in nodes:
		var new_button = user_brush_button.instance()
		if new_button is UserBrushButton:
			new_button.user_brush = node
			$GridContainer.add_child(new_button)
		
