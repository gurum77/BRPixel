extends Camera2D

const MAX_ZOOM_LEVEL = 0.02
const MIN_ZOOM_LEVEL = 50.0
const ZOOM_INCREMENT = 0.05

signal moved()
signal zoomed()

var _current_zoom_level = 1
var _drag = false

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
	if event.is_action_pressed("cam_drag"):
		_drag = true
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
