extends TextureRect
class_name LayerButton

func _ready():
	update()
	update_layer_preview()
	
func _process(_delta):
	update()
	
func update_layer_preview(layer=null):
	if layer == null:
		layer= get_layer()
	if layer == null:
		return
	$Layer.image = layer.image
	$Layer.modulate.a = layer.modulate.a
	$Layer.update_texture()
	
func get_layer_index()->int:
	var layers = NodeManager.get_current_layers()
	if layers == null:
		return 0
		
	var layer_count = layers.get_normal_layers().size()
	var idx = get_parent().get_parent().get_index()
	return layer_count - idx - 1
	
func is_current_layer()->bool:
	if NodeManager.get_current_layer() == null:
		return false
		
	if NodeManager.get_current_layer().get_index() == get_layer_index():
		return true
	return false

func _on_Timer_timeout():
	if is_current_layer():
		update_layer_preview()

func get_layer()->Layer:
	if NodeManager.get_current_layers() == null:
		return null
		
	return NodeManager.get_current_layers().get_layer(get_layer_index())
	
func update():
	# tree에 추가되지 않은 상태에서는 get_layer_index()가 없으므로 일시적으로 null일 수 있음
	if get_layer() == null:
		$CurrentLayerSign.visible = false
		return
		
	if get_layer().visible:
		modulate = Color.white
	else:
		modulate = Color.darkgray
#	$CurrentLayerSign.visible = is_current_layer()


func _on_LayerButton_gui_input(event):
	# L 버튼 클릭시 현재 layer로 설정
#	if InputManager.is_action_just_pressed_lbutton(event):
#		StaticData.current_layer_index = get_layer_index()
	if InputManager.is_action_just_pressed_rbutton(event):
		get_layer().toggle_visible()
		update()
			
