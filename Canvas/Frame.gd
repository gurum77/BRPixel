extends Control
class_name Frame

var unused = false

func get_save_dic()->Dictionary:
	var _save_dic:Dictionary
	_save_dic["layers"] = get_save_dic_layers()
	return _save_dic
	
func get_save_dic_layers()->Dictionary:
	var _save_dic:Dictionary
	var layers = get_layers().get_normal_layers()
	for layer in layers:
		if !layer.is_need_to_save():
			continue
		_save_dic[layer.get_index()] = layer.get_save_dic()
	return _save_dic
		
func set_save_dic(dic:Dictionary):
	# 기존 레이어를 제거한다.
	get_layers().clear_normal_layers()

	if !dic.has("layers"):
		return
	var dic_layers:Dictionary = dic["layers"]
	
	for key in dic_layers.keys():
		# layer 추가
		var new_layer = get_layers().add_layer()
		new_layer.set_save_dic(dic_layers[key])
		
func get_layers()->Layers:
	return $Layers as Layers

func make_layers():
	get_layers().clear_normal_layers()
	# 첫번째 frame의 layer 갯수
	var layer_count = NodeManager.get_frames().get_frame(0).get_layers().get_normal_layers().size()
	for i in layer_count:
		var _layer = get_layers().add_layer()

# 현재 frame이 아니라면 가린다.
func _process(_delta):
	visible = get_index() == StaticData.current_frame_index
