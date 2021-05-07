extends Control
class_name DraggableFileDialog
var file_button = preload("res://FileButton.tscn")
var path = "c://"
var dir = Directory.new()
var result_ok = true
var selected_file_paths = []	# 선택한 파일 경로들

onready var file_button_parent = $DraggableWindow/ScrollContainer/GridContainer
onready var file_name_line_edit = $DraggableWindow/ColorRect/HBoxContainer2/FileNameLineEdit
onready var selected_file_nums_label = $DraggableWindow/ColorRect/HBoxContainer2/SelectedFileNumsLabel
onready var new_folder_name_Line_edit = $DraggableWindow/HBoxContainer/AddFolderButton/NewFolderNamePopup/HBoxContainer/NewFolderNameLineEdit
onready var new_folder_name_popup = $DraggableWindow/HBoxContainer/AddFolderButton/NewFolderNamePopup
onready var drive_button = $DraggableWindow/HBoxContainer/DriveButton
export var multi_selection = false	# 여러개 선택 가능한지?
export var save_file_dialog = true	# 저장인지?
export var default_extension = "pex"
export var filters:PoolStringArray	# filter
export var default_file_name = ""	# 기본 파일 명

# 표시 가능한 확장자
var enabled_extenstions:Dictionary
func _ready():
	if is_windows():
		path = "c://"
	else:
		path = "user://"
	dir.open(path)
	update_lsit()
	
func is_windows():
	if OS.get_name() == "Windows":
		return true
	return false
	
# 접근 가능한 root인지?
# windows는 무제한 접근가능
func is_root():
	return dir.get_current_dir() == path
		
func get_last_selected_file_path()->String:
	if selected_file_paths == null || selected_file_paths.size() == 0:
		return ""
	return selected_file_paths[selected_file_paths.size()-1]
	
func get_directorie_names()->Array:
	var is_windows = is_windows()
	var is_root = is_root()
	dir.list_dir_end()
	dir.list_dir_begin()
	var directories = []
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir() && file_name != ".":
			if !is_windows:
				if is_root && file_name == "..":
					file_name = dir.get_next()
					continue
			directories.append(file_name)
		file_name = dir.get_next()
	return directories
	
func get_file_names()->Array:
	dir.list_dir_end()
	dir.list_dir_begin()
	var files = []
	var file_name = dir.get_next()
	while file_name != "":
		if !dir.current_is_dir():
			var ext = file_name.get_extension()
			if enabled_extenstions.has(ext):
				files.append(file_name)
		file_name = dir.get_next()
	return files
	
func update_lsit():
	# 현재 경로 갱신
	update_path_line_edit()
	
	enabled_extenstions.clear()
	for filter in filters:
		var text = filter as String
		var splits = text.split(";", true, 1)
		if splits.size() == 0:
			continue
			
		enabled_extenstions[splits[0].get_extension()] = true
	
	var nodes = file_button_parent.get_children()
	for node in nodes:
		node.call_deferred("queue_free")
	
	# 정렬을 위해서 디렉토리와 파일을 따로 읽는다.
	var directorie_names = get_directorie_names()
	var file_names = get_file_names()
	
	# 디렉토리 버튼 추가
	add_file_buttons(directorie_names, true)
	# 파일 버튼 추가 
	add_file_buttons(file_names, false)
	
	
	
func add_file_buttons(names:Array, is_directory):
	for name in names:
		var ins:FileButton = file_button.instance()
		ins.is_directory = is_directory
		ins.directory_path = dir.get_current_dir()
		ins.file_name = name
		var _tmp = ins.connect("pressed", self, "on_file_button_pressed", [ins])
		file_button_parent.add_child(ins)
			
func enabled_multiple_selection()->bool:
	if save_file_dialog:
		return false
	return multi_selection
	
# 파일을 선택하면 선택 표시만 한다.
# 디렉토리를 선택하면 이동한다.
func on_file_button_pressed(_file_button:FileButton):
	if _file_button.is_directory:
		dir.change_dir(_file_button.file_name)
		update_lsit()
	else:
		if !enabled_multiple_selection():
			unselect_all(_file_button)
		file_name_line_edit.text = _file_button.file_name
	update_selected_file_nums_label(1)	
	
func unselect_all(except_file_button):
	var nodes = file_button_parent.get_children()
	for node in nodes:
		if except_file_button == node:
			continue
		node.pressed = false
		
func popup_centered():
	selected_file_paths.clear()
	visible = true
	result_ok = false
	file_name_line_edit.text = default_file_name
	
	$DraggableWindow.popup_centered()
	update_lsit()
	
	# filter가 하나라면 그걸 default ext로 준다.
	if enabled_extenstions.size() == 1:
		default_extension = enabled_extenstions.keys()[0]

# 현재 directory에 폴더 생성
func _on_AddFolderButton_pressed():
	$DraggableWindow/HBoxContainer/AddFolderButton/NewFolderNamePopup.popup_centered()
	update_lsit()
	
func is_exist_file(_file_name)->bool:
	return dir.file_exists(_file_name)
	
func _on_OkButton_pressed():
	# 선택한 파일
	selected_file_paths.clear()
	
	# 저장인 경우 파일명 
	if save_file_dialog:
		var file_name_with_ext = Util.get_file_name_with_ext(file_name_line_edit.text, default_extension, enabled_extenstions)
		
		selected_file_paths.append(Util.get_file_path(dir.get_current_dir(), file_name_with_ext))
		
		# 이미 존재하는 파일이면 덮어 쓸건지 물어본다.
		if is_exist_file(file_name_with_ext):
			$MessageBox.message = "File exists. Overwrite?"
			$MessageBox.popup_centered()
			return
	else:
		var file_name_with_ext = Util.get_file_name_with_ext(file_name_line_edit.text, default_extension, enabled_extenstions)
		selected_file_paths.append(Util.get_file_path(dir.get_current_dir(), file_name_with_ext))

		
	result_ok = true
	hide()

# 경로 표시줄을 업데이트 한다.
func update_path_line_edit():
	$DraggableWindow/HBoxContainer/PathLineEdit.text = dir.get_current_dir()
	
# 파일명이 변경될 때 마다 실제 파일이 있는지 확인하고 선택을 해준다.
func _on_FileNameLineEdit_text_changed(new_text):
	var nums = 0
	var nodes = file_button_parent.get_children()
	for node in nodes:
		var btn = node as FileButton
		if new_text != "" && btn.file_name.begins_with(new_text):
			btn.pressed = true
			nums += 1
		else:
			btn.pressed = false
	update_selected_file_nums_label(nums)
			
func update_selected_file_nums_label(nums):
	selected_file_nums_label.text = str(nums) + tr(" file(s) selected")

# 새 폴더를 만든다.
func _on_NewFolderOkButton_pressed():
	new_folder_name_popup.hide()
	var result = dir.make_dir(new_folder_name_Line_edit.text)
	if result == OK:
		update_lsit()
		return
	Util.show_message(self, "Error", "Failed to create new folder.")
	

# overwrite?
func _on_MessageBox_hide():
	if $MessageBox.result == $MessageBox.Result.yes:
		result_ok = true
		hide()



