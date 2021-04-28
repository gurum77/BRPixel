extends Node

class_name UndoManager_DeleteLayer

# undo data for delete layer
var origin_current_frame_index = 0
var origin_current_layer_index = 0
var origin_layer:Layer


func prepare_undo_for_delete_layer():
	origin_current_frame_index = StaticData.current_frame_index
	origin_current_layer_index = StaticData.current_layer_index

func commit_undo_for_delete_layer(delete_frame_index:int, delete_layer_index:int):
	var layer = NodeManager.get_layer(delete_frame_index, delete_layer_index)
	if layer == null:
		return
		
	origin_layer = layer.clone()
	
	StaticData.undo_redo.create_action("delete_layer")
	StaticData.undo_redo.add_undo_method(self, "undo_delete_layer", origin_layer, origin_current_frame_index, origin_current_layer_index, delete_frame_index, delete_layer_index)
	StaticData.undo_redo.add_do_method(self, "do_delete_layer", delete_frame_index, delete_layer_index)
	StaticData.undo_redo.commit_action()
	StaticData.undo_count += 1

func undo_delete_layer(_origin_layer:Layer, _origin_current_frame_index:int, _origin_current_layer_index:int, _delete_frame_index:int, _delete_layer_index:int):
	var frame = NodeManager.get_frames().get_frame(_delete_frame_index)
	var layer = frame.get_layers().add_layer_by_layer(_origin_layer, _delete_layer_index)
	if layer == null:
		return
	layer.update_texture()
	
	StaticData.current_frame_index = _origin_current_frame_index
	StaticData.current_layer_index = _origin_current_layer_index
	
	NodeManager.get_layer_panel().regen_layer_buttons()
	
func do_delete_layer(delete_frame_index:int, delete_layer_index:int):
	# 현재 layer를 지우고 다음 layer를 현재 layer로 설정한다.
	var frame = NodeManager.get_frame(delete_frame_index)
	if(frame == null):
		return
	frame.get_layers().remove_layer(delete_layer_index)
	
	# layer button을 재생성 한다.
	NodeManager.get_layer_panel().regen_layer_buttons()
