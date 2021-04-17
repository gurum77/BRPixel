extends Control
class_name Frame

func get_layers()->Layers:
	return $Layers as Layers

func make_layers():
	get_layers().clear_normal_layers()
	# 첫번째 frame의 layer 갯수
	var layer_count = NodeManager.get_current_frames().get_frame(0).get_layers().get_normal_layers().size()
	for i in layer_count:
		get_layers().add_layer()

# 현재 frame이 아니라면 가린다.
func _process(delta):
	visible = get_index() == StaticData.current_frame_index
