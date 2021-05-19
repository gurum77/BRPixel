extends MenuButton

var dir = Directory.new()
var file_dialog:DraggableFileDialog = null
func _ready():
	# windows용일때만 표시
	if OS.get_name() == "Windows":
		visible = true
		file_dialog = get_parent().get_parent().get_parent()
		var _result = get_popup().connect("id_pressed", self, "on_id_pressed")
	else:
		visible = false
	

func update_text():
	text = file_dialog.dir.get_drive(file_dialog.dir.get_current_drive())
	
func on_id_pressed(ID):
	file_dialog.path = dir.get_drive(ID)
	file_dialog.dir.change_dir(file_dialog.path)
	file_dialog.update_lsit()
	update_text()
	
func _on_DriveButton_pressed():
	get_popup().clear()
	# 선택 가능한 drive 목록을 메뉴로 추가한다.
	var drive_count = dir.get_drive_count()
	for index  in drive_count:
		var drive = dir.get_drive(index)
		get_popup().add_item(drive)
	
