extends TextureRect

var layer_index = 0
func _ready():
	update()
	update_layer()
	
func update_layer():
	
	if NodeManager.get_layers()== null:
		return
		
	var nodes = NodeManager.get_layers().get_children()
	if layer_index < 0 || nodes.size() <= layer_index:
		return
	$Layer.image = nodes[layer_index].image
	$Layer.update_texture()
	

func is_current_layer()->bool:
	if StaticData.current_layer == null:
		return false
		
	if StaticData.current_layer.index == layer_index:
		return true
	return false

func _on_Timer_timeout():
	if is_current_layer():
		update_layer()

func get_layer()->Layer:
	return NodeManager.get_layers().get_layer(layer_index)
	
func update():
	if get_layer().visible:
		modulate = Color.white
	else:
		modulate = Color.gray
	$CurrentLayerSign.visible = is_current_layer()


func _on_LayerButton_gui_input(event):
	# layer button 클릭시
	if event is InputEventMouseButton:
		# L 버튼 클릭시 현재 layer로 설정
		if Input.is_action_just_pressed("left_button"):
			StaticData.current_layer = get_layer()
			NodeManager.get_layer_panel().update_layer_buttons()
		elif Input.is_action_just_pressed("right_button"):
			get_layer().toggle_visible()
			update()
			
		
