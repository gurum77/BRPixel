extends Camera2D

const MAX_ZOOM_LEVEL = 0.02
const MIN_ZOOM_LEVEL = 50.0
const ZOOM_INCREMENT = 0.05

signal moved()
signal zoomed()

var _current_zoom_level = 1
var _drag = false
var events = {}
var last_drag_distance = 0
var zoom_sensitivity = 2
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
	
	
func _input(event):
#	if StaticData.invalid_mouse_pos_for_tool(StaticData.current_tool):
#		return
		

#	if event is InputEventScreenTouch:
#		touching = true
#		if event.pressed:
#			events[event.index] = event
#		else:
#			events.erase(event.index)
#	if event is InputEventScreenDrag:
#		touching = true
#		events[event.index] = event
#		debug_label.text = str(events.size())
#		if events.size() == 1:
#			last_drag_distance = 0
#		if events.size() == 2:
#			var drag_distance = events[0].position.distance_to(events[1].position)
#			if last_drag_distance == 0:
#				last_drag_distance = drag_distance
#			debug_label.text = "last_drag_distance : " + str(last_drag_distance) + "drag_distance : " + str(drag_distance) + "\nzoom_sensitivity : " + str(zoom_sensitivity)
#			debug_label.text = debug_label.text + "\nevents[0] : " + str(events[0].position.x) + "," + str(events[0].position.y)
#			debug_label.text = debug_label.text + "\nevents[1] : " + str(events[1].position.x) + "," + str(events[1].position.y) 
#
##			if abs(drag_distance - last_drag_distance) > zoom_sensitivity:
##				if drag_distance < last_drag_distance:
##					_update_zoom(ZOOM_INCREMENT, (events[0].position + events[1].position)/2)
##				else:
##					_update_zoom(-ZOOM_INCREMENT, (events[0].position + events[1].position)/2)
##			else:
#			debug_label.text = "relative : " + str(event.relative.x) + "," + str(event.relative.y)
#			set_offset(get_offset() - event.relative *_current_zoom_level)
#			emit_signal("moved")
#			last_drag_distance = drag_distance
			
	if !touching:
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
			set_offset(get_offset() - event.relative*_current_zoom_level)
			emit_signal("moved")

func _update_zoom(incr, zoom_anchor):
	if touching:
		return
	var old_zoom = _current_zoom_level
	_current_zoom_level += incr
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
