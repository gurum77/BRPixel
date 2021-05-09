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
	
# layer의 이름을 변경한다.
func set_layer_name(index:int, new_name:String):
	
	var frame_count = NodeManager.get_frames().get_frame_count()
	for frame_index in frame_count:
		var frame = NodeManager.get_frames().get_frame(frame_index)
		if frame == null:
			continue
		var layer = frame.get_layers().get_layer(index)
		if layer == null:
			continue
		layer.name = new_name
	

func make_layers():
	get_layers().clear_normal_layers()
	# 첫번째 frame의 layer 갯수
	var first_frame = NodeManager.get_frames().get_frame(0)
	var layer_count = first_frame.get_layers().get_normal_layers().size()
	for i in layer_count:
		var first_layer = first_frame.get_layers().get_layer(i)
		var _layer = get_layers().add_layer()
		_layer.copy_properties(first_layer)
		

# 현재 frame이 아니라면 가린다.
func _process(_delta):
	visible = get_index() == StaticData.current_frame_index
