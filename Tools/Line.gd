extends Control
class_name LineTool
var start_point = Vector2(0, 0)
var end_point = Vector2(0, 0)
func _ready():
	NodeManager.get_tools().init_to_start_tool(self, StaticData.Tool.line)
	
func _draw():
	if StaticData.current_tool != StaticData.Tool.line:
		return
	var points = GeometryMaker.get_pixels_in_line(start_point, end_point, StaticData.pencil_thickness)
	var pixel_with_colors = GeometryMaker.get_pixel_with_colors_by_brush_type(points, true)
	StaticData.preview_layer.clear()
	StaticData.preview_layer.set_pixel_with_colors(pixel_with_colors)
		
func drawing_area_input(_event):
	if StaticData.invalid_mouse_pos_for_tool(StaticData.Tool.line):
		return
	if StaticData.current_tool != StaticData.Tool.line:
		return
	
	InputManager.draw_preview_pixel_cursor(self, _event, StaticData.pencil_thickness)
	
	if InputManager.is_action_just_pressed_lrbutton(_event):
		UndoManager.draw_pixels_on_current_layer.prepare_undo_for_draw_on_current_layer()
		start_point = get_local_mouse_position()
		StaticData.current_user_brush_destination_point = start_point
	elif InputManager.is_action_just_released_lrbutton(_event):
		end_point = get_local_mouse_position()
		if start_point == null:
			start_point = end_point
			
		end_point = GeometryMaker.get_end_point_by_orthomode(start_point, end_point)
		var points = GeometryMaker.get_pixels_in_line(start_point, end_point, StaticData.pencil_thickness)
		var pixel_with_colors = GeometryMaker.get_pixel_with_colors_by_brush_type(points)
		NodeManager.get_current_layer().set_pixel_with_colors(pixel_with_colors)
		UndoManager.draw_pixels_on_current_layer.append_undo_for_draw_on_current_layer(pixel_with_colors.keys())
		UndoManager.draw_pixels_on_current_layer.commit_undo_for_draw_on_current_layer()
		StaticData.preview_layer.clear(true)
		
	if InputManager.is_action_pressed_lrbutton(_event):
		end_point = get_local_mouse_position()
		end_point = GeometryMaker.get_end_point_by_orthomode(start_point, end_point)
		update()
		
