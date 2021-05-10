extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$DraggablePopup/GridContainer/TitleTextEdit.set_message_translation(false)


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

func _on_128x128Button_pressed():
	$DraggablePopup/GridContainer/WidthTextEdit.text = "128"
	$DraggablePopup/GridContainer/HeightTextEdit.text = "128"


func _on_256x256Button_pressed():
	$DraggablePopup/GridContainer/WidthTextEdit.text = "256"
	$DraggablePopup/GridContainer/HeightTextEdit.text = "256"

func _on_OkButton_pressed():
	var width = $DraggablePopup/GridContainer/WidthTextEdit.text.to_int()
	var height = $DraggablePopup/GridContainer/HeightTextEdit.text.to_int()
	if width < Define.min_canvas_size || height < Define.min_canvas_size:
		Util.show_message(self, "minimum canvas size : " + str(Define.max_canvas_size))
	if width > Define.max_canvas_size || height > Define.max_canvas_size:
		Util.show_message(self, "minimum canvas size : " + str(Define.max_canvas_size))
		
	# project name
	StaticData.project_name = $DraggablePopup/GridContainer/TitleTextEdit.text
	
	# canvas 크기 설정
	StaticData.canvas_width = width
	StaticData.canvas_height = height
	NodeManager.get_canvas().resize()
	
	# frame을 모두 제거하고 1개만 추가한다.
	NodeManager.get_frames().clear_frames()
	# 한타임 돌고 와야함(그래야 tree가 갱신됨)
	yield(get_tree().create_timer(0.1), "timeout")
	
	var _frame = NodeManager.get_frames().add_frame("Frame1", false)
	
	# layer도 하나 추가한다.
	_frame.get_layers().add_layer("Layer 1")
	
	# 한타임 돌고 와야함(그래야 tree가 갱신됨)
	yield(get_tree().create_timer(0.1), "timeout")
	
	StaticData.current_frame_index = 0
	StaticData.current_layer_index = 0
	
	# preview layer 크기 변경
	StaticData.preview_layer.resize(Layer.ResizeDir.right_bottom)
	
	# frame 버튼 갱신
	NodeManager.get_frame_panel().regen_frame_buttons()
	# layer 버튼 갱신
	NodeManager.get_layer_panel().regen_layer_buttons()
	
	$DraggablePopup.hide()
	NodeManager.get_setting_popup().hide()

	# 새파일을 auto save
	StaticData.save_auto_saved_project()	


func _on_CancelButton_pressed():
	$DraggablePopup.hide()


