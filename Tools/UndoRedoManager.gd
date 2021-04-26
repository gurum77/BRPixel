extends Node

var undo_redo:UndoRedo = UndoRedo.new()
var undo_data_for_draw_pixels_on_current_layer

func undo_draw_pixels_on_current_layer(current_frame_index, current_layer_index):
	StaticData.current_frame_index = current_frame_index
	StaticData.current_layer_index = current_layer_index
	NodeManager.get_current_layer().update_texture()
	
	
func redo_draw_pixels_on_current_layer(current_frame_index, current_layer_index):
	StaticData.current_frame_index = current_frame_index
	StaticData.current_layer_index = current_layer_index
	NodeManager.get_current_layer().update_texture()
	
func add_undo_draw_pixels_on_current_layer(image:Image):
	undo_redo.create_action("draw_pixels_on_current_layer")
	
	undo_redo.add_undo_property(image, "data", undo_data_for_draw_pixels_on_current_layer)
	undo_redo.add_undo_method(self, "undo_draw_pixels_on_current_layer", StaticData.current_frame_index, StaticData.current_layer_index)
	
	undo_redo.add_do_property(image, "data", image.data)
	undo_redo.add_do_method(self, "redo_draw_pixels_on_current_layer", StaticData.current_frame_index, StaticData.current_layer_index)
	
	undo_redo.commit_action()
	
