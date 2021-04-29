extends Node

class_name UndoManager_DrawPixelsOnCurrentLayer

# undo data for draw_pixels
var origin_image:Image = null
var new_pixels:Dictionary

func undo_draw_pixels_on_current_layer(current_frame_index:int, current_layer_index:int, pixel_with_colors:Dictionary):
	StaticData.current_frame_index = current_frame_index
	StaticData.current_layer_index = current_layer_index
	var layer = NodeManager.get_current_layer()
	layer.set_pixel_with_colors(pixel_with_colors)
	
	
func do_draw_pixels_on_current_layer(current_frame_index:int, current_layer_index:int, pixel_with_colors:Dictionary):
	StaticData.current_frame_index = current_frame_index
	StaticData.current_layer_index = current_layer_index
	var layer = NodeManager.get_current_layer()
	layer.set_pixel_with_colors(pixel_with_colors)
	
func prepare_undo_for_draw_on_current_layer():
	origin_image = NodeManager.get_current_layer().image.duplicate()
	new_pixels.clear()
	
func get_pixels_by_rect(var rect:Rect2)->Array:
	var pixels = []
	for x in range(rect.position.x as int, rect.end.x as int):
		for y in range(rect.position.y as int, rect.end.y as int):
			pixels.append(Vector2(x, y))
	return pixels
	
func append_undo_for_draw_on_current_layer_by_Rect(var rect:Rect2):
	append_undo_for_draw_on_current_layer(get_pixels_by_rect(rect))
	
func append_undo_for_draw_on_current_layer_by_2Rects(var rect1:Rect2, var rect2:Rect2):
	append_undo_for_draw_on_current_layer_by_Rect(rect1)
	append_undo_for_draw_on_current_layer_by_Rect(rect2)
			
func append_undo_for_draw_on_current_layer(var pixels:Array):
	for pixel in pixels:
		new_pixels[pixel] = true
	
func commit_undo_for_draw_on_current_layer():
	var image = NodeManager.get_current_layer().image
	
	var origin_pixel_with_colors = Util.get_pixel_with_colors(origin_image, new_pixels.keys(), false)
	var new_pixel_with_colors = Util.get_pixel_with_colors(image, new_pixels.keys(), false)
	
	NodeManager.get_undo().create_action("draw_pixels_on_current_layer")
	
#	undo_redo.add_undo_property(image, "data", undo_data_for_draw_pixels_on_current_layer)
	NodeManager.get_undo().add_undo_method(self, "undo_draw_pixels_on_current_layer", StaticData.current_frame_index, StaticData.current_layer_index, origin_pixel_with_colors)
	
#	undo_redo.add_do_property(image, "data", image.data)
	NodeManager.get_undo().add_do_method(self, "do_draw_pixels_on_current_layer", StaticData.current_frame_index, StaticData.current_layer_index, new_pixel_with_colors)
	
	NodeManager.get_undo().commit_action()
	NodeManager.increase_undo_count()
	
