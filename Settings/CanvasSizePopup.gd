extends Control

onready var left_top_button = $DraggablePopup/DirGridContainer/LeftTopButton
onready var top_button = $DraggablePopup/DirGridContainer/TopButton
onready var right_top_button = $DraggablePopup/DirGridContainer/RightTopButton
onready var left_button = $DraggablePopup/DirGridContainer/LeftButton
onready var center_button = $DraggablePopup/DirGridContainer/CenterButton
onready var right_button = $DraggablePopup/DirGridContainer/RightButton
onready var left_bottom_button = $DraggablePopup/DirGridContainer/LeftBottomButton
onready var bottom_button = $DraggablePopup/DirGridContainer/BottomButton
onready var right_bottom_button = $DraggablePopup/DirGridContainer/RightBottomButton
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func popup_centered():
	$DraggablePopup.popup_centered()
	$DraggablePopup.rect_position.y = $DraggablePopup.rect_position.y - $DraggablePopup.rect_size.y/2
	
func _on_OkButton_pressed():
	# 입력값 체크
	var width = $DraggablePopup/GridContainer/WidthTextEdit.text.to_int()
	var height = $DraggablePopup/GridContainer/HeightTextEdit.text.to_int()
	# 값이 같으면 그냥 닫는다.
	if StaticData.canvas_width == width && StaticData.canvas_height == height:
		$DraggablePopup.hide()
		return
		
	if width < Define.min_canvas_size || height < Define.min_canvas_size:
		Util.show_message($DraggablePopup, "error", "minimum cavas size : " + str(Define.min_canvas_size))
		return
	if width > Define.max_canvas_size || height > Define.max_canvas_size:
		Util.show_message($DraggablePopup, "error", "maximum cavas size : " + str(Define.max_canvas_size))
		return
	
	# canvas 사이즈 변경
	# 변수값 변경
	StaticData.canvas_width = width
	StaticData.canvas_height = height
	
	# canvas를 크기를 조정
	NodeManager.get_canvas().resize()

	# layer의 크기를 조정 
	var layers = NodeManager.get_current_layers().get_children()
	for layer in layers:
		layer.resize(get_resize_dir())
	# preview layer 크기 조정
	StaticData.preview_layer.resize(get_resize_dir())
	
	$DraggablePopup.hide()

func get_resize_dir()->int:
	if left_top_button.pressed:
		return Layer.ResizeDir.left_top
	elif top_button.pressed:
		return Layer.ResizeDir.top
	elif right_top_button.pressed:
		return Layer.ResizeDir.right_top
	elif left_button.pressed:
		return Layer.ResizeDir.left
	elif center_button.pressed:
		return Layer.ResizeDir.center
	elif right_button.pressed:
		return Layer.ResizeDir.right
	elif left_bottom_button.pressed:
		return Layer.ResizeDir.left_bottom
	elif bottom_button.pressed:
		return Layer.ResizeDir.bottom
	elif right_bottom_button.pressed:
		return Layer.ResizeDir.right_bottom
	return Layer.ResizeDir.center	
	

func _on_CancelButton_pressed():
	$DraggablePopup.hide()

func _on_DraggablePopup_about_to_show():
	$DraggablePopup/GridContainer/WidthTextEdit.text = str(StaticData.canvas_width)
	$DraggablePopup/GridContainer/HeightTextEdit.text = str(StaticData.canvas_height)
	

func press_button_only(button):
	left_top_button.pressed = false
	top_button.pressed = false
	right_top_button.pressed = false
	left_button.pressed = false
	center_button.pressed = false
	right_button.pressed = false
	left_bottom_button.pressed = false
	bottom_button.pressed = false
	right_bottom_button.pressed = false
	button.pressed = true
	
func _on_LeftTopButton_pressed():
	press_button_only(left_top_button)


func _on_TopButton_pressed():
	press_button_only(top_button)


func _on_RightTopButton_pressed():
	press_button_only(right_top_button)


func _on_CenterButton_pressed():
	press_button_only(center_button)


func _on_LeftButton_pressed():
	press_button_only(left_button)


func _on_LeftBottomButton_pressed():
	press_button_only(left_bottom_button)


func _on_BottomButton_pressed():
	press_button_only(bottom_button)


func _on_RightBottonButton_pressed():
	press_button_only(right_bottom_button)


func _on_RightButton_pressed():
	press_button_only(right_button)
