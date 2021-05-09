extends WindowDialog
class_name LayerPanel

var layer_button_node = preload("res://Canvas/LayerButton.tscn")
var layer_info_noide = preload("res://Settings/LayerInfo.tscn")
var add_layer_button_on_layer_panel = preload("res://AddLayerButtonOnLayerPanel.tscn")
onready var layer_button_parent = $VBoxContainer/ScrollContainer/HBoxContainer
# layer button의 layer 갱
func update_layer_buttons():
	var nodes = layer_button_parent.get_children()
	for node in nodes:
		if node is LayerInfo:
			node.update_layer_preview()
			node.update_control()
	update_all_visible_button()
		
# layer button을 다시 만든다.
func regen_layer_buttons():
	# 기존 layer panel에 있는 layer 버튼을 제거
	var nodes = layer_button_parent.get_children()
	for node in nodes:
		node.queue_free()
		
	# layer 버튼을 새로 만든다.
	# 순서를 거꾸로 한다.
	var normal_layers = NodeManager.get_current_layers().get_normal_layers()
	for node in normal_layers:
		if not node is Layer:
			continue
		var layer_button = layer_info_noide.instance()
		layer_button_parent.add_child(layer_button)
		layer_button_parent.move_child(layer_button, 0)
		layer_button.update_layer_preview(node as Layer)
		layer_button.update_control(node as Layer)
		
	update_all_visible_button()
	
func is_all_invisible():
	var normal_layers = NodeManager.get_current_layers().get_normal_layers()
	for node in normal_layers:
		if node.visible:
			return false
	return true
	
func _ready():
	show()
	update_all_visible_button()


func update_all_visible_button():
	$VBoxContainer/HBoxContainer/VisibleAllButton.pressed = !is_all_invisible()

# 모드 켜거나 끈다
func _on_VisibleAllButton_pressed():
	var all_visible = $VBoxContainer/HBoxContainer/VisibleAllButton.pressed
	var normal_layers = NodeManager.get_current_layers().get_normal_layers()
	for node in normal_layers:
		node.visible = all_visible
	update_layer_buttons()


func _on_LayerPanel_resized():
	$VBoxContainer/ScrollContainer.rect_min_size.y = rect_size.y - 50
