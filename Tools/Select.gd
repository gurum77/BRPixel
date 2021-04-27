extends Control
class_name Select
var pressed = false

var start_point = Vector2(0, 0)
var end_point = Vector2(0, 0)
var grip_node = preload("res://Grip.tscn")
var grips = []
var color = Color.yellowgreen
var boundary_color = Color.yellowgreen
var edit_mode = false
var use_preview_layer = false

onready var grip_parent = self

func _ready():
	NodeManager.get_tools().init_to_start_tool(self, StaticData.Tool.select, !use_preview_layer)
	color.a = 0.3
	boundary_color.a = 1.0
	StaticData.dragging_grip = false
	
func _draw():
	if StaticData.invalid_mouse_pos_for_tool(StaticData.Tool.select) && !StaticData.enabled_selected_area():
		return
		
	var points = get_grip_points()
	if points.size() < 3:
		return
	draw_colored_polygon(points, color)
	draw_polyline(points, boundary_color)
	
		
func get_grip_points()->PoolVector2Array:
	var points = PoolVector2Array()
	if grips.size() == 0:
		return points
	for grip in grips:
		points.append(grip.get_global_center_position())
	points.append(grips[0].get_global_center_position())
	return points


func _input(_event):
	if StaticData.invalid_mouse_pos_for_tool(StaticData.Tool.select):
		# dragging중인 grip이 있고 grip중 하나라도 preview라면 교착상태에 빠진다.
		# preview가 하나라도 있다면 dragging은 불가하므로 dragging 상태를 푼다.
		if StaticData.dragging_grip:
			for grip in grips:
				if grip.preview:
					StaticData.dragging_grip = false
		return
	
	if is_mouse_on_grip():
		pass
	else:
		if InputManager.is_action_just_pressed_lbutton(_event):
			start_point = get_local_mouse_position()
			start_point.x = start_point.x as int
			start_point.y = start_point.y as int
			pressed = true
			# 마우스를 클릭할때 preview grip을 만든다
			make_grips(true)
		elif InputManager.is_action_just_released_lbutton(_event):
			if pressed:
				end_point = get_local_mouse_position()
				end_point.x = end_point.x as int
				end_point.y = end_point.y as int
				pressed = false
				# 마우스를 떼면 그립을 진짜 grip을 만들고 selected area를 갱신한다.
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
	set_selected_area_by_grip_points()
	
func clear_grips():
	var nodes = grip_parent.get_children()
	for n in nodes:
		n.queue_free()
	grips.clear()
	StaticData.clear_selected_area()
		
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
	set_selected_area_by_grip_points()
	
# grip 좌표로 selected area를 설정한다.
func set_selected_area_by_grip_points():
	StaticData.set_selected_area(get_grip_points())
	
# grip을 다시 만든다.
func make_grips(preview):
	clear_grips()
	grips.append(make_grip(Grip.Type.left_bottom, preview))
	grips.append(make_grip(Grip.Type.right_bottom, preview))
	grips.append(make_grip(Grip.Type.right_top, preview))
	grips.append(make_grip(Grip.Type.left_top, preview))
	set_selected_area_by_grip_points()

	
# grip 위에 mouse가 있는지?
func is_mouse_on_grip()->bool:
	var nodes = get_children()
	for node in nodes:
		if node.is_mouse_entered():
			return true
	return false


func _on_Select_tree_exited():
	StaticData.clear_selected_area()
