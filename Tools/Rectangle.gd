extends Control
class_name RectangleTool

var fill = false
var start_point = Vector2(0, 0)
var end_point = Vector2(0, 0)

func _ready():
	NodeManager.get_tools().init_to_start_tool(self, StaticData.Tool.rectangle)
	
func _draw():
	if StaticData.current_tool != StaticData.Tool.rectangle:
		return
	var points = GeometryMaker.get_pixels_in_rectangle(start_point, end_point, fill, StaticData.pencil_thickness)
	var pixel_with_colors = GeometryMaker.get_pixel_with_colors_by_brush_type(points)
	StaticData.preview_layer.clear()
	StaticData.preview_layer.set_pixel_with_colors(pixel_with_colors)
		
	return points
		
func drawing_area_input(_event):
	if StaticData.invalid_mouse_pos_for_tool(StaticData.Tool.rectangle):
		return
		
	InputManager.draw_preview_pixel_cursor(self, _event, StaticData.pencil_thickness)
	
	if InputManager.is_action_just_pressed_lbutton(_event):
		UndoManager.draw_pixels_on_current_layer.prepare_undo_for_draw_on_current_layer()
		start_point = get_local_mouse_position()
		StaticData.current_user_brush_destination_point = start_point
	elif InputManager.is_action_just_released_lbutton(_event):
		end_point = get_local_mouse_position()
		end_point = GeometryMaker.get_end_point_by_orthomode(start_point, end_point)
		var points = GeometryMaker.get_pixels_in_rectangle(start_point, end_point, fill, StaticData.pencil_thickness)
		var pixel_with_colors = GeometryMaker.get_pixel_with_colors_by_brush_type(points)
		NodeManager.get_current_layer().set_pixel_with_colors(pixel_with_colors)
		StaticData.preview_layer.clear(true)
		UndoManager.draw_pixels_on_current_layer.append_undo_for_draw_on_current_layer(pixel_with_colors.keys())
		UndoManager.draw_pixels_on_current_layer.commit_undo_for_draw_on_current_layer()
		
	if InputManager.is_action_pressed_lbutton(_event):
		end_point = get_local_mouse_position()
		end_point = GeometryMaker.get_end_point_by_orthomode(start_point, end_point)
		update()
