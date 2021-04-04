extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func popup_centered():
	$DraggablePopup.popup_centered()

func _on_16x16Button_pressed():
	$DraggablePopup/GridContainer/WidthTextEdit.text = "16"
	$DraggablePopup/GridContainer/HeightTextEdit.text = "16"


func _on_32x32Button_pressed():
	$DraggablePopup/GridContainer/WidthTextEdit.text = "32"
	$DraggablePopup/GridContainer/HeightTextEdit.text = "32"


func _on_64x64Button_pressed():
	$DraggablePopup/GridContainer/WidthTextEdit.text = "64"
	$DraggablePopup/GridContainer/HeightTextEdit.text = "64"


func _on_OkButton_pressed():
	var width = $DraggablePopup/GridContainer/WidthTextEdit.text.to_int()
	var height = $DraggablePopup/GridContainer/HeightTextEdit.text.to_int()
	if width < Define.min_canvas_size || height < Define.min_canvas_size:
		Util.show_message(self, "minimum canvas size : " + str(Define.max_canvas_size))
	if width > Define.max_canvas_size || height > Define.max_canvas_size:
		Util.show_message(self, "minimum canvas size : " + str(Define.max_canvas_size))
		
	# canvas 크기 설정
	StaticData.canvas_width = width
	StaticData.canvas_height = height
	NodeManager.get_canvas().resize()
	
	# layer 모두 제거하고 1개만 ..
	NodeManager.get_layers().clear_normal_layers()
	
	StaticData.current_layer = NodeManager.get_layers().add_layer("Layer1")
	NodeManager.get_layers().update_layer_index()
	
	# preview layer 크기 변경
	StaticData.preview_layer.resize(Layer.ResizeDir.right_bottom)
	
	# layer 버튼 갱신
	NodeManager.get_layer_panel().regen_layer_buttons()
	
	$DraggablePopup.hide()
	NodeManager.get_setting_popup().hide()
	


func _on_CancelButton_pressed():
	$DraggablePopup.hide()
