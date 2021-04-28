extends Node
class_name UndoManager_AddLayer

# undo data for delete layer
var origin_current_frame_index = 0	# 추가 되기전 현재 frame
var origin_current_layer_index = 0	# 추가 되기전 현재 layer
var added_frame_index = 0

func prepare_add_layer():
	origin_current_frame_index = StaticData.current_frame_index
	origin_current_layer_index = StaticData.current_layer_index

func commit_add_layer(_added_frame_index:int):
	StaticData.undo_redo.create_action("add_layer")
	StaticData.undo_redo.add_undo_method(self, "undo_add_layer", origin_current_frame_index, origin_current_layer_index)
	StaticData.undo_redo.add_do_method(self, "do_add_layer", _added_frame_index)
	StaticData.undo_redo.commit_action()
	StaticData.undo_count += 1

# add layer를 undo 한다.
# 마지막 layer를 삭제한다.
func undo_add_layer(_origin_current_frame_index:int, _origin_current_layer_index:int):
	var frame = NodeManager.get_frames().get_frame(_origin_current_frame_index)
	frame.get_layers().remove_layer(frame.get_layers().get_normal_layers().size()-1)
	
	StaticData.current_frame_index = _origin_current_frame_index
	StaticData.current_layer_index = _origin_current_layer_index
	
	NodeManager.get_layer_panel().regen_layer_buttons()
	
func do_add_layer(_added_frame_index:int):
	# layer를 추가한다.
	NodeManager.get_frame(_added_frame_index).get_layers().add_layer()
	
	# 현재 layer index를 마지막 layer로 설정한다.
	StaticData.current_layer_index = NodeManager.get_current_layers().get_child_count()-1
	
	# laye button 갱신
	NodeManager.get_layer_panel().regen_layer_buttons()
