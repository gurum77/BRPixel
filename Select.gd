extends Control

var pressed = false

var start_point = Vector2(0, 0)
var end_point = Vector2(0, 0)
var grip_node = preload("res://Grip.tscn")
var grips = []
var color = Color.yellowgreen
var boundary_color = Color.yellowgreen
onready var grip_parent = self
func _ready():
	color.a = 0.3
	boundary_color.a = 1.0
	pass
	
func _draw():
	if StaticData.invalid_mouse_pos_for_tool(StaticData.Tool.select):
		return
		
	var points = get_grip_points()
	draw_colored_polygon(points, color)
	draw_polyline(points, boundary_color)
	
		
func get_grip_points()->PoolVector2Array:
	var points = PoolVector2Array()
	for grip in grips:
		points.append(grip.get_global_center_position())
	points.append(grips[0].get_global_center_position())
	return points


func _input(_event):
	if StaticData.invalid_mouse_pos_for_tool(StaticData.Tool.select):
		return
	
	if is_mouse_on_grip():
		pass
	else:
		if Input.is_action_just_pressed("left_button"):
			start_point = get_local_mouse_position()
			start_point.x = start_point.x as int
			start_point.y = start_point.y as int
			pressed = true
			# 마우스를 클릭할때 preview grip을 만든다
			make_grips(true)
		elif Input.is_action_just_released("left_button"):
			if pressed:
				end_point = get_local_mouse_position()
				end_point.x = end_point.x as int
				end_point.y = end_point.y as int
				pressed = false
				# 마우스를 떼면 그립을 진짜 grip을 만든다.
				make_grips(false)
				update()
			
			
		if pressed:
			end_point =  get_local_mouse_position()
			end_point.x = end_point.x as int
			end_point.y = end_point.y as int
			# 이동중일때는 grip 위치 갱신
			refresh_grips()
			update()
		
func refresh_grips():
	var nodes = grip_parent.get_children()
	for node in nodes:
		node.rect_position = get_grip_position(node.type)
	
func clear_grips():
	var nodes = grip_parent.get_children()
	for n in nodes:
		n.queue_free()
	grips.clear()
		
# grip의 타입에 따른 위치를 리턴한다.
func get_grip_position(grip_type)->Vector2:
	if grip_type == Grip.Type.left_bottom:
		return Vector2(min(start_point.x, end_point.x), min(start_point.y, end_point.y))	
	elif grip_type == Grip.Type.right_bottom:
		return Vector2(max(start_point.x, end_point.x), min(start_point.y, end_point.y))
	elif grip_type == Grip.Type.right_top:
		return Vector2(max(start_point.x, end_point.x), max(start_point.y, end_point.y))
	return Vector2(min(start_point.x, end_point.x), max(start_point.y, end_point.y))
		
func make_grip(grip_type, preview)->Node:
	var grip = grip_node.instance()
	grip.type = grip_type
	grip.rect_position = get_grip_position(grip_type)
	grip.preview = preview
	grip_parent.add_child(grip)
	
	grip.connect("moved", self, "on_grip_moved", [grip])
	return grip

func get_grip_by_type(grip_type)->Grip:
	var nodes = get_children()
	for node in nodes:
		if node.type == grip_type:
			return node as Grip
	return null
	
# grip이 움직이면 grip다른 그립도 위치를 조정한다.
func on_grip_moved(grip):
	var griplt = get_grip_by_type(Grip.Type.left_top)
	var griprb = get_grip_by_type(Grip.Type.right_bottom)
	var griplb = get_grip_by_type(Grip.Type.left_bottom)
	var griprt = get_grip_by_type(Grip.Type.right_top)
	if grip.type == Grip.Type.left_bottom:
		griplt.rect_position.x = grip.rect_position.x
		griprb.rect_position.y = grip.rect_position.y
	elif grip.type == Grip.Type.right_bottom:
		griplb.rect_position.y = grip.rect_position.y
		griprt.rect_position.x = grip.rect_position.x
	elif grip.type == Grip.Type.right_top:
		griplt.rect_position.y = grip.rect_position.y
		griprb.rect_position.x = grip.rect_position.x
	elif grip.type == Grip.Type.left_top:
		griplb.rect_position.x = grip.rect_position.x
		griprt.rect_position.y = grip.rect_position.y
	update()
	
func make_grips(preview):
	clear_grips()
	grips.append(make_grip(Grip.Type.left_bottom, preview))
	grips.append(make_grip(Grip.Type.right_bottom, preview))
	grips.append(make_grip(Grip.Type.right_top, preview))
	grips.append(make_grip(Grip.Type.left_top, preview))
	
	
# grip 위에 mouse가 있는지?
func is_mouse_on_grip()->bool:
	var nodes = get_children()
	for node in nodes:
		if node.is_mouse_entered():
			return true
	return false
