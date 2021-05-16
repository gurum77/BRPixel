extends Control
class_name ImportImagePopup
export var image_file_path = ""

onready var preview = $DraggableWindow/VBoxContainer/Background/Preview
onready var background = $DraggableWindow/VBoxContainer/Background
onready var src_label = $DraggableWindow/VBoxContainer/InfoVBoxContainer/SourceInfoLabel
onready var tar_label = $DraggableWindow/VBoxContainer/InfoVBoxContainer/TargetInfoLabel
onready var error_label  = $DraggableWindow/VBoxContainer/InfoVBoxContainer/ErrorLabel
var result_ok = false
	
func popup_centered():
	result_ok = false
	show()
	$DraggableWindow.popup_centered()
	var image = Util.load_image_file(self, image_file_path)
	Util.update_preview_image(preview, image)
	update_infomations()


func update_infomations():
	if preview.texture.image != null:
		src_label.text = "%s : %d x %d" % [tr("Source image"),preview.texture.get_width(), preview.texture.get_height()]
	else:
		src_label.text = "%s : ..." % [tr("Source image")]
	
	var target_image_width = preview.texture.get_width() / preview.cols
	var target_image_height = preview.texture.get_height() / preview.rows
	var frames = preview.cols * preview.rows
	tar_label.text = "%s : %d x %d, %d %s" % [tr("Target image"), target_image_width, target_image_height, frames, tr("frame")]
	
	# error message
	if is_too_big_image():
		error_label.text = "Maximum image size is %d." % [Define.max_canvas_size]
		$DraggableWindow/VBoxContainer/Container/OkButton.disabled = true
		$DraggableWindow/VBoxContainer/Container/OkButton.modulate = Color.darkgray
	else:
		error_label.text = ""
		$DraggableWindow/VBoxContainer/Container/OkButton.disabled = false
		$DraggableWindow/VBoxContainer/Container/OkButton.modulate = Color.white
	
func is_too_big_image()->bool:
	var target_image_width = preview.texture.get_width() / preview.cols
	var target_image_height = preview.texture.get_height() / preview.rows
	if target_image_width > Define.max_canvas_size:
		return true
	if target_image_height > Define.max_canvas_size:
		return true
	return false

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



