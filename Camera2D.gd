extends Camera2D

const MAX_ZOOM_LEVEL = 0.02
const MIN_ZOOM_LEVEL = 50.0
const ZOOM_INCREMENT = 0.02

signal moved()
signal zoomed()

var _current_zoom_level = 1
var _drag = false
var events = {}
var last_drag_distance = 0
var last_zoom_level = 1
var last_drag_position:Vector2
var zoom_sensitivity = 20
var zoom_speed = 0.05
var touching = false
func _ready():
	pass

#onready var debug_label = get_tree().root.get_node_or_null("Main/UI/DebugLabel")
# canvas가 꽉차게 zoom fit을 한다.
func zoom_fit():
	set_offset(Vector2(StaticData.canvas_width/2, StaticData.canvas_height/2))
	var screen_width = get_viewport_rect().size.x
	var screen_height = get_viewport_rect().size.y
	var screen_min = min(screen_width, screen_height)
	var canvas_max = max(StaticData.canvas_width, StaticData.canvas_height)
	if screen_min == 0:
		return
	var scale = canvas_max / screen_min
	# 여백의 미(10%)
	_current_zoom_level = scale + scale / 10
	set_zoom(Vector2(_current_zoom_level, _current_zoom_level))

func get_drag_distance()->float:
	if events.size() < 2:
		return 0.0
	return events[0].position.distance_to(events[1].position)	
	
func get_relative()->Vector2:
	return Vector2(floor(events[1].x - events[0].x), floor(events[1].y - events[0].y))
	
func get_angle()->float:
	var vec1 = events[0].relative.normalized() as Vector2
	var vec2 = events[1].relative.normalized() as Vector2
	return abs(vec1.angle_to(vec2))

func is_touch_inside_drawing_area(event)->bool:
	var rect = NodeManager.get_drawing_area().get_rect()
	if rect.position.x > event.position.x:
		return false
	if rect.position.y > event.position.y:
		return false
	if rect.end.x < event.position.x:
		return false
	if rect.end.y < event.position.y:
		return false
		
	return true
	
# gui input은 event.index 1 이 안됨. 
# zoom이 제대로 되게 하려면 Camera는 반드시 DrawingArea node 뒤에 위치해야
func _input(event):
	# 어디선가 text 편집 중이라면 zoom 하지 말자.
	if InputManager.text_editing:
		return
	if InputManager.is_exist_showing_popup():
		return
		
	# touch screen drag인지?
	if event is InputEventScreenTouch:
		if !is_touch_inside_drawing_area(event):
			return
			
		if event.pressed:
			events[event.index] = event
			last_drag_distance = get_drag_distance()
			last_zoom_level = _current_zoom_level
			last_drag_position = event.position
		else:
			events.erase(event.index)
#			NodeManager.get_debug_label().text = "events.erase(event.index) %d" % event.index
			# zoom을 하다가 손을 떼면 마지막 drawing tool을 실행
			# 동작중이던 drawing tool을 종료하는 효과가 있음.
			if StaticData.current_tool == StaticData.Tool.zoom && events.size() == 0:
#				NodeManager.get_debug_label().text = "NodeManager.get_tools().run_last_drawing_tool()"
				# 0.1초후에 drawing tool을 실행한다.
				# 바로 해버리면 drawing tool에 event가 가서 원치않는 그림이 그려지기도 하기 때문 
				yield(get_tree().create_timer(0.1), "timeout")
				NodeManager.get_tools().run_last_drawing_tool()
			
	elif event is InputEventScreenDrag:
		if !is_touch_inside_drawing_area(event):
			return
			
		if events.size() != 2:
			return
		
		events[event.index] = event
		var drag_distance = get_drag_distance()
		
		# index가 1일때만 반응하자(0일때도 하면 두배로 zoom이 된다)
		if event.index == 1:
			var ang = get_angle()

			# pan			
			if ang < 1:
				set_offset(get_offset() - event.relative *_current_zoom_level)
				
			# zoom
			var center_position = (events[0].position + events[1].position) / 2
			center_position = get_viewport().canvas_transform.affine_inverse().xform(center_position)
			var new_zoom_level = last_zoom_level * (last_drag_distance / drag_distance)
			_update_zoom_by_new_zoom_level(new_zoom_level, center_position)
			last_drag_position = event.position
			
			# zooming 이라면 현재 tool을 zoom으로 변경
			# 지금 그리기 중이었던 명령은 취소를 한다.
			UndoManager.draw_pixels_on_current_layer.cancel_undo_for_draw_on_current_layer()
			StaticData.current_tool = StaticData.Tool.zoom
	# 아닌지
	else:
		if StaticData.mouse_inside_ui:
			return

		if event.is_action_pressed("cam_drag"):
			_drag = true
#			debug_label.text = "cam_drag"
		elif event.is_action_released("cam_drag"):
			_drag = false
		elif event.is_action("cam_zoom_in"):
			_update_zoom(-ZOOM_INCREMENT, get_local_mouse_position())
		elif event.is_action("cam_zoom_out"):
			_update_zoom(ZOOM_INCREMENT, get_local_mouse_position())
		elif event is InputEventMouseMotion && _drag:
#			NodeManager.get_debug_label().text = "pan, relative:" + str(event.relative)
			set_offset(get_offset() - event.relative*_current_zoom_level)
			emit_signal("moved")
		
func _update_zoom_by_new_zoom_level(new_zoom_level, zoom_anchor):
	var old_zoom = _current_zoom_level
	_current_zoom_level = new_zoom_level
	
	if _current_zoom_level < MAX_ZOOM_LEVEL:
		_current_zoom_level = MAX_ZOOM_LEVEL
	elif _current_zoom_level > MIN_ZOOM_LEVEL:
		_current_zoom_level = MIN_ZOOM_LEVEL
	if old_zoom == _current_zoom_level:
		return
	
	var zoom_center = zoom_anchor - get_offset()
	var ratio = 1-_current_zoom_level/old_zoom
	set_offset(get_offset() + zoom_center*ratio)
	
	set_zoom(Vector2(_current_zoom_level, _current_zoom_level))
	emit_signal("zoomed")
	
func _update_zoom(incr, zoom_anchor):
	if touching:
		return
	_update_zoom_by_new_zoom_level(_current_zoom_level + incr, zoom_anchor)
	
