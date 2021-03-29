extends Control

var pressed = false

var start_point = Vector2(0, 0)
var end_point = Vector2(0, 0)
var grip_node = preload("res://Grip.tscn")

func _ready():
	pass
	
func _draw():
	if StaticData.invalid_mouse_pos_for_tool(StaticData.Tool.select):
		return
		
	var points = GeometryMaker.get_pixels_in_rectangle(start_point, end_point)
	StaticData.preview_layer.clear()
	StaticData.preview_layer.set_pixels_by_current_color(points)
		
		
	return points
		
func _input(_event):
	if StaticData.invalid_mouse_pos_for_tool(StaticData.Tool.select):
		return
	
	if Input.is_action_just_pressed("left_button"):
		start_point = get_local_mouse_position()
		start_point.x = start_point.x as int
		start_point.y = start_point.y as int
		pressed = true
		var nodes = NodeManager.get_grips().get_children()
		for n in nodes:
			n.queue_free()
	elif Input.is_action_just_released("left_button"):
		end_point = get_local_mouse_position()
		end_point.x = end_point.x as int
		end_point.y = end_point.y as int
		# 마우스를 떼면 그립을 4개 만든다.
		make_grips()
		pressed = false
		
	if pressed:
		end_point =  get_local_mouse_position()
		update()
		
func make_grips():
	# left_bottom
	var griplb = grip_node.instance()
	griplb.type = Grip.Type.left_bottom
	griplb.rect_position = Vector2(min(start_point.x, end_point.x), min(start_point.y, end_point.y))
	NodeManager.get_grips().add_child(griplb)
	
	# right_bottom
	var griprb = grip_node.instance()
	griprb.type = Grip.Type.right_bottom
	griprb.rect_position = Vector2(max(start_point.x, end_point.x), min(start_point.y, end_point.y))
	NodeManager.get_grips().add_child(griprb)
	
	# left_top
	var griplt = grip_node.instance()
	griplt.type = Grip.Type.left_top
	griplt.rect_position = Vector2(min(start_point.x, end_point.x), max(start_point.y, end_point.y))
	NodeManager.get_grips().add_child(griplt)
	
	# right_top
	var griprt = grip_node.instance()
	griprt.type = Grip.Type.right_top
	griprt.rect_position = Vector2(max(start_point.x, end_point.x), max(start_point.y, end_point.y))
	NodeManager.get_grips().add_child(griprt)
		
		
