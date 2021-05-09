extends Control
class_name LayerInfo

onready var layer_button = $HBoxContainer/LayerButton
onready var current_layer_sign = $CurrentLayerSign

func update_layer_preview(layer:Layer):
	layer_button.update_layer_preview(layer)

func get_layer()->Layer:
	return layer_button.get_layer()
	
func _ready():
	update_control()
	
func is_current_layer()->bool:
	return layer_button.is_current_layer()
	
func update_control(layer:Layer=null):
	if layer == null:
		layer = get_layer()
	if layer == null:
		$CurrentLayerSign.visible = false
		return
	$HBoxContainer/VisibleButton.pressed = layer.visible
	$HBoxContainer/NameLineEdit.text = layer.name
	
func _process(_delta):
	current_layer_sign.visible = is_current_layer()


func _on_VisibleButton_pressed():
	var layer = get_layer()
	if layer == null:
		return
	layer.visible = $HBoxContainer/VisibleButton.pressed
	update_control()
	NodeManager.get_layer_panel().update_all_visible_button()

func is_valid_layer_name(name)->bool:
	if name == null || name == "":
		return false
	var layer = get_layer()
	if layer != null && layer.name == name:
		return true
	
	# 다른 layer의 이름과 같을 수 없다.
	var layers = NodeManager.get_current_layers()
	if layers == null:
		return true
	var normal_layers = layers.get_normal_layers()
	if normal_layers == null:
		return true
	for l in normal_layers:
		if l == layer:
			continue
		if l.name == name:
			return false
	return true
		


func _on_NameLineEdit_focus_exited():
	var new_text = $HBoxContainer/NameLineEdit.text
	if !is_valid_layer_name(new_text):
		update_control()
		return
		
	var layer = get_layer()
	if layer == null:
		return
		
	layer.name = new_text


func _on_LayerSettingButton_pressed():
	NodeManager.get_layer_setting_popup().selected_layer = get_layer()
	NodeManager.get_layer_setting_popup().popup_centered()

func update_all_layer_info_control():
	NodeManager.get_layer_panel().update_layer_buttons()
	
func _on_NameLineEdit_focus_entered():
	var layer = get_layer()
	if layer == null:
		return
	StaticData.current_layer_index = layer.get_index()
	update_control()
	update_all_layer_info_control()
	$Tween.interpolate_property($CurrentLayerSign, "rect_rotation", 0, 1, 0.2, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($CurrentLayerSign, "rect_rotation", 1, 0, 0.2, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	$Tween.start()


func _on_LayerButton_gui_input(event):
	if InputManager.is_action_just_pressed_lbutton(event):
		_on_NameLineEdit_focus_entered()
