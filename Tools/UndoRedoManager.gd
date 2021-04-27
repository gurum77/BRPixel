extends Node

var undo_redo:UndoRedo = UndoRedo.new()

# undo data for draw_pixels
var origin_image:Image = null
var new_pixels:Dictionary

# undo data for delete layer
var origin_current_frame_index = 0
var origin_current_layer_index = 0
var origin_layer:Layer
var undo_count:int = 0

func undo_draw_pixels_on_current_layer(current_frame_index:int, current_layer_index:int, pixel_with_colors:Dictionary):
	StaticData.current_frame_index = current_frame_index
	StaticData.current_layer_index = current_layer_index
	var layer = NodeManager.get_current_layer()
	layer.set_pixel_with_colors(pixel_with_colors)
	
	
func redo_draw_pixels_on_current_layer(current_frame_index:int, current_layer_index:int, pixel_with_colors:Dictionary):
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
	
	var origin_pixel_with_colors = Util.get_pixel_with_colors(origin_image, new_pixels.keys())
	var new_pixel_with_colors = Util.get_pixel_with_colors(image, new_pixels.keys())
	
	undo_redo.create_action("draw_pixels_on_current_layer")
	
#	undo_redo.add_undo_property(image, "data", undo_data_for_draw_pixels_on_current_layer)
	undo_redo.add_undo_method(self, "undo_draw_pixels_on_current_layer", StaticData.current_frame_index, StaticData.current_layer_index, origin_pixel_with_colors)
	
#	undo_redo.add_do_property(image, "data", image.data)
	undo_redo.add_do_method(self, "redo_draw_pixels_on_current_layer", StaticData.current_frame_index, StaticData.current_layer_index, new_pixel_with_colors)
	
	undo_redo.commit_action()
	undo_count += 1

func prepare_undo_for_delete_layer():
	origin_current_frame_index = StaticData.current_frame_index
	origin_current_layer_index = StaticData.current_layer_index

func commit_undo_for_delete_layer(delete_frame_index:int, delete_layer_index:int):
	var layer = NodeManager.get_layer(delete_frame_index, delete_layer_index)
	if layer == null:
		return
		
	origin_layer = layer.duplicate()
	
	undo_redo.create_action("delete_layer")
	undo_redo.add_undo_method(self, "undo_delete_layer", origin_layer, origin_current_frame_index, origin_current_layer_index, delete_frame_index, delete_layer_index)
	undo_redo.add_do_method(self, "do_delete_layer", delete_frame_index, delete_layer_index)
	undo_redo.commit_action()
	undo_count += 1

func undo_delete_layer(origin_layer:Layer, origin_current_frame_index:int, origin_current_layer_index:int, delete_frame_index:int, delete_layer_index:int):
	var layer = NodeManager.get_frames().get_frame(delete_frame_index).get_layers().add_layer(origin_layer.name, delete_layer_index)
	if layer == null:
		return
	NodeManager.get_layer_panel().update_layer_buttons()
	
func do_delete_layer(delete_frame_index:int, delete_layer_index:int):
	# 현재 layer를 지우고 다음 layer를 현재 layer로 설정한다.
	var frame = NodeManager.get_frame(delete_frame_index)
	if(frame == null):
		return
	frame.get_layers().remove_layer(delete_layer_index)
	
	# layer button을 재생성 한다.
	NodeManager.get_layer_panel().regen_layer_buttons()
