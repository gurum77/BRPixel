extends Control

export var image_file_path = ""

onready var preview = $DraggableWindow/VBoxContainer/Background/Preview
onready var background = $DraggableWindow/VBoxContainer/Background

func popup_centered():
	show()
	$DraggableWindow.popup_centered()
	var image = Util.load_image_file(self, image_file_path)
	preview.texture = ImageTexture.new()
	preview.texture.create_from_image(image)
	preview.texture.flags = 0	# filter 등 모든 롭션을 끔(2d pixel 스타일로 그려야 함)
	preview.update()
	preview.rect_position.x = background.rect_size.x / 2 - image.get_width() / 2
	preview.rect_position.y = background.rect_size.y / 2 - image.get_height() / 2
	
	
func hide():
	hide()
	$DraggableWindow.hide()


func _on_SpinBox_value_changed(value):
	preview.cols = value
	preview.update()
