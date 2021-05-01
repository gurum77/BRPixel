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

onready var debug_label = get_tree().root.get_node_or_null("Main/UI/DebugLabel")
# canvas가 꽉차게 zoom fit을 한다.
func zoom_fit():
	set_offset(Vector2(StaticData.canvas_width/2, StaticData.canvas_height/2))
	var screen_width = get_viewport_rect().size.x
	var screen_height = get_viewport_rect().size.y
	var screen_min = min(screen_width, screen_height)
	var canvas_max = max(StaticData.canvas_width, StaticData.canvas_height)
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
	
func _input(event):
	if StaticData.mouse_inside_ui:
		return

	# touch screen drag인지?
	if event is InputEventScreenTouch:
		if event.pressed:
			events[event.index] = event
			last_drag_distance = get_drag_distance()
			last_zoom_level = _current_zoom_level
			last_drag_position = event.position
		else:
			events.erase(event.index)
			
	elif event is InputEventScreenDrag:
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
	# 아닌지
	else:
		if event.is_action_pressed("cam_drag"):
			_drag = true
			debug_label.text = "cam_drag"
		elif event.is_action_released("cam_drag"):
			_drag = false
		elif event.is_action("cam_zoom_in"):
			_update_zoom(-ZOOM_INCREMENT, get_local_mouse_position())
		elif event.is_action("cam_zoom_out"):
			_update_zoom(ZOOM_INCREMENT, get_local_mouse_position())
		elif event is InputEventMouseMotion && _drag:
			NodeManager.get_debug_label().text = "pan, relative:" + str(event.relative)
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
	
