extends Control
class_name CircleTool
var fill = false
var start_point = Vector2(0, 0)
var end_point = Vector2(0, 0)
func _ready():
	NodeManager.get_tools().init_to_start_tool(self, StaticData.Tool.circle)
	
func _draw():
	if StaticData.current_tool != StaticData.Tool.circle:
		return
	var points = GeometryMaker.get_pixels_in_circle(start_point, end_point, fill, StaticData.pencil_thickness)
	StaticData.preview_layer.clear()
	StaticData.preview_layer.set_pixels_by_current_color(points)
		
		
	return points
		
func _input(_event):
	if StaticData.invalid_mouse_pos_for_tool(StaticData.Tool.circle):
		return
	
	InputManager.draw_preview_pixel_cursor(self, _event, StaticData.pencil_thickness)
	
	if InputManager.is_action_just_pressed_lbutton(_event):
		UndoManager.draw_pixels_on_current_layer.prepare_undo_for_draw_on_current_layer()
		start_point = get_local_mouse_position()
	elif InputManager.is_action_just_released_lbutton(_event):
		end_point = get_local_mouse_position()
		var points = GeometryMaker.get_pixels_in_circle(start_point, end_point, fill, StaticData.pencil_thickness)
		NodeManager.get_current_layer().set_pixels_by_current_color(points)
		StaticData.preview_layer.clear(true)
		UndoManager.draw_pixels_on_current_layer.append_undo_for_draw_on_current_layer(points)
		UndoManager.draw_pixels_on_current_layer.commit_undo_for_draw_on_current_layer()
		
	if InputManager.is_action_pressed_lbutton(_event):
		end_point = get_local_mouse_position()
		update()
