extends Control
class_name ImportImagePopup
export var image_file_path = ""

onready var preview = $DraggableWindow/VBoxContainer/Background/Preview
onready var background = $DraggableWindow/VBoxContainer/Background
onready var src_label = $DraggableWindow/VBoxContainer/InfoVBoxContainer/SourceInfoLabel
onready var tar_label = $DraggableWindow/VBoxContainer/InfoVBoxContainer/TargetInfoLabel
var result_ok = false

func update_preview_image(_preview, _image):
	var image_width = _image.get_width()
	var image_height = _image.get_height()
	
	# 이미지가 texture보다 크다면 scale에 margin은 0으로 하고 expand를 true 한다.
	# 이미지가 texture보다 작다면 keep centered 로 하고 expand는 false를 한다.
	if image_width > _preview.rect_size.x || image_height > _preview.rect_size.y:
		_preview.expand = true
		_preview.stretch_mode = TextureRect.STRETCH_SCALE_ON_EXPAND
	else:
		_preview.expand = false
		_preview.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED

	# preview에 image를 그린다
	_preview.texture = ImageTexture.new()
	_preview.texture.create_from_image(_image)
	_preview.texture.flags = 0	# filter 등 모든 롭션을 끔(2d pixel 스타일로 그려야 함)
	_preview.update()
	_preview.rect_position.x = _preview.get_parent().rect_size.x / 2 - image_width / 2
	_preview.rect_position.y = _preview.get_parent().rect_size.y / 2 - image_height / 2
	_preview.margin_bottom = 0
	_preview.margin_left = 0
	_preview.margin_right = 0
	_preview.margin_top = 0
	
func popup_centered():
	result_ok = false
	show()
	$DraggableWindow.popup_centered()
	var image = Util.load_image_file(self, image_file_path)
	update_preview_image(preview, image)
	update_infomations()


func update_infomations():
	if preview.texture.image != null:
		src_label.text = "Source image : %d x %d" % [preview.texture.get_width(), preview.texture.get_height()]
	else:
		src_label.text = "Source image : ..."
	
	var target_image_width = preview.texture.get_width() / preview.cols
	var target_image_height = preview.texture.get_height() / preview.rows
	var frames = preview.cols * preview.rows
	tar_label.text = "Target image : %d x %d, %d frames" % [target_image_width, target_image_height, frames]

func _on_SpinBox_value_changed(value):
	preview.cols = value
	preview.update()
	update_infomations()

func _on_RowsSpinBox_value_changed(value):
	preview.rows = value
	preview.update()
	update_infomations()
	
func _on_OkButton_pressed():
	result_ok = true
	hide()	


func _on_CancelButton_pressed():
	result_ok = false
	hide()



