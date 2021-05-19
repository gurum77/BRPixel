extends Control
class_name DraggableFileDialog
var file_button = preload("res://FileButton.tscn")
var file_detailview_button = preload("res://FileDetailViewButton.tscn")
var path = "c://"
var dir = Directory.new()
var file = File.new()
var result_ok = true
var selected_file_paths = []	# 선택한 파일 경로들
var visible_other_controls:Dictionary
var selected_file_nums = 0	# 선택되어 있는 파일 개수

onready var file_button_parent = $DraggableWindow/ScrollContainer/GridContainer
onready var file_name_line_edit = $DraggableWindow/ColorRect/HBoxContainer2/FileNameLineEdit
onready var selected_file_nums_label = $DraggableWindow/ColorRect/HBoxContainer2/SelectedFileNumsLabel
onready var new_folder_name_Line_edit = $DraggableWindow/HBoxContainer/AddFolderButton/NewFolderNamePopup/HBoxContainer/NewFolderNameLineEdit
onready var new_folder_name_popup = $DraggableWindow/HBoxContainer/AddFolderButton/NewFolderNamePopup
onready var drive_button = $DraggableWindow/HBoxContainer/DriveButton
onready var sort_by_name_button = $DraggableWindow/HBoxContainer/SortByNameButton
onready var sort_by_date_button = $DraggableWindow/HBoxContainer/SortByDateButton

export var multi_selection = false	# 여러개 선택 가능한지?
export var save_file_dialog = true	# 저장인지?
export var default_extension = "pex"
export var filters:PoolStringArray	# filter
export var default_file_name = ""	# 기본 파일 명

export var file_button_size = Vector2(150, 100)
export var file_detailview_button_size = Vector2(300, 30)
export var file_button_offset = Vector2(20, 20)
export var file_detailview_button_offset = Vector2(10, 5)

enum Sort{by_name, by_name_r, by_date, by_date_r}
var sort_method = Sort.by_name

# 표시 가능한 확장자
var enabled_extenstions:Dictionary

func _ready():
	if is_windows():
		path = "c://"
	else:
		path = "user://"
	dir.open(path)
	update_lsit()
	
	var godot_get_image = PluginManager.get_godot_get_image()
	if godot_get_image != null:
		godot_get_image.connect("image_request_completed", self, "_on_image_request_completed")
	
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
	
func sort_by_name(s1:String, s2:String):
	if s1 == "..":
		return true
	if s2 == "..":
		return false
	if s1.to_lower() > s2.to_lower():
		return true
	return false
	
func sort_by_name_r(s1:String, s2:String):
	if s1 == "..":
		return true
	if s2 == "..":
		return false
	if s1.to_lower() < s2.to_lower():
		return true
	return false	
func sort_by_date(s1:String, s2:String):
	if s1 == "..":
		return true
	if s2 == "..":
		return false
	var path1 = Util.get_file_path(dir.get_current_dir(), s1)
	var path2 = Util.get_file_path(dir.get_current_dir(), s2)
	if file.get_modified_time(path1) > file.get_modified_time(path2):
		return true
	return false
func sort_by_date_r(s1:String, s2:String):
	if s1 == "..":
		return true
	if s2 == "..":
		return false
	var path1 = Util.get_file_path(dir.get_current_dir(), s1)
	var path2 = Util.get_file_path(dir.get_current_dir(), s2)
	if file.get_modified_time(path1) < file.get_modified_time(path2):
		return true
	return false	
		
func sort_files(files:Array):
	if sort_method == Sort.by_name:
		files.sort_custom(self, "sort_by_name")
		pass
	elif sort_method == Sort.by_name_r:
		files.sort_custom(self, "sort_by_name_r")
		pass
	elif sort_method == Sort.by_date:
		files.sort_custom(self, "sort_by_date")
	elif sort_method == Sort.by_date_r:
		files.sort_custom(self, "sort_by_date_r")
	
func get_directorie_names()->Array:
	var is_windows = is_windows()
	var is_root = is_root()
	dir.list_dir_end()
	dir.list_dir_begin()
	var directories = []
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir() && file_name != "." && !file_name.begins_with("$"):
			if !is_windows:
				if is_root && file_name == "..":
					file_name = dir.get_next()
					continue
			directories.append(file_name)
		file_name = dir.get_next()
	sort_files(directories)
	return directories
	
func get_file_names()->Array:
	dir.list_dir_end()
	dir.list_dir_begin()
	var files = []
	var file_name = dir.get_next()
	while file_name != "":
		if !dir.current_is_dir():
			var ext = file_name.get_extension()
			ext = ext.to_lower()
			if enabled_extenstions.has(ext):
				files.append(file_name)
		file_name = dir.get_next()
	sort_files(files)
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
		var ext = splits[0].get_extension()
		ext = ext.to_lower()
		enabled_extenstions[ext] = true
	
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
	var detail_view = is_detail_view()
	var button_size = file_button_size
	if detail_view:
		button_size = file_detailview_button_size
		button_size.x = $DraggableWindow.rect_size.x - 50
		
	for name in names:
		var ins
		
		if detail_view:
			ins = file_detailview_button.instance()
		else:
			ins = file_button.instance()
		
		ins.is_directory = is_directory
		ins.directory_path = dir.get_current_dir()
		ins.file_name = name
		ins.rect_min_size = button_size
		ins.rect_size = button_size
		var _tmp = ins.connect("pressed", self, "on_file_button_pressed", [ins])
		file_button_parent.add_child(ins)
			
func enabled_multiple_selection()->bool:
	if save_file_dialog:
		return false
	return multi_selection
	
# 파일을 선택하면 선택 표시만 한다.
# 디렉토리를 선택하면 이동한다.
func on_file_button_pressed(_file_button):
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
	
	
func hide_other_control(control:Control):
	visible_other_controls[control] = control.visible
	control.hide()
	
func show_other_control(control:Control):
	if visible_other_controls.has(control):
		if visible_other_controls[control]:
			control.show()
		else:
			control.hide()
	else:
		control.show()
	
func hide_other_controls():
	hide_other_control(NodeManager.get_layer_panel())	
	hide_other_control(NodeManager.get_preview())	
	
func show_other_controls():
	show_other_control(NodeManager.get_layer_panel())	
	show_other_control(NodeManager.get_preview())	
	
func popup_centered():
	hide_other_controls()
	selected_file_paths.clear()
	visible = true
	result_ok = false
	file_name_line_edit.text = default_file_name
	
	$DraggableWindow.popup_centered()
	update_lsit()
	
	# filter가 하나라면 그걸 default ext로 준다.
	if enabled_extenstions.size() == 1:
		default_extension = enabled_extenstions.keys()[0]
		
	# 그리드의 columns 설정
	set_grid_columns()
	
	# 저장용인 경우 photo button은 비활성화 한다.
	$DraggableWindow/HBoxContainer/PhotoButton.disabled = save_file_dialog
	
# 자세히 보기 인지?
func is_detail_view():
	return $DraggableWindow/HBoxContainer/DetailViewButton.pressed
	
# 그리드 columns 설정
func set_grid_columns():
	var grid = file_button_parent as GridContainer
	if grid != null:
		if is_detail_view():
			grid.columns = 1
			grid.set("custom_constants/vseparation", file_detailview_button_offset.y)
			grid.set("custom_constants/hseparation", file_detailview_button_offset.x)
		else:
			var rect_size = $DraggableWindow.rect_size
			grid.columns = rect_size.x / (file_button_size.x + file_button_offset.x)
			grid.set("custom_constants/vseparation", file_button_offset.y)
			grid.set("custom_constants/hseparation", file_button_offset.x)
		
		
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
		# 열기인 경우 반드시 파일이 1개 선택되어 있어야 함
		if selected_file_nums != 1:
			return

		var file_name_with_ext = Util.get_file_name_with_ext(file_name_line_edit.text, default_extension, enabled_extenstions)
		selected_file_paths.append(Util.get_file_path(dir.get_current_dir(), file_name_with_ext))

		
	result_ok = true
	hide()

# 경로 표시줄을 업데이트 한다.
func update_path_line_edit():
	$DraggableWindow/HBoxContainer/PathLineEdit.text = dir.get_current_dir()
	
# 파일명이 변경될 때 마다 실제 파일이 있는지 확인하고 선택을 해준다.
# 하나만 선택되는 경우라면 line edit에 그 파일명을 적어준다.
func _on_FileNameLineEdit_text_changed(new_text):
	var last_selected_file_name = ""
	var is_directory = true
	var nums = 0
	var nodes = file_button_parent.get_children()
	for node in nodes:
		if new_text != "" && node.file_name.begins_with(new_text):
			last_selected_file_name = node.file_name
			is_directory = node.is_directory
			node.pressed = true
			nums += 1
		else:
			node.pressed = false
	update_selected_file_nums_label(nums)

	# 한개만 선택된 경우라면 자동완성한다.	
	if nums == 1 && !is_directory:
		$DraggableWindow/ColorRect/HBoxContainer2/FileNameLineEdit.text = last_selected_file_name
		$DraggableWindow/ColorRect/HBoxContainer2/FileNameLineEdit.caret_position = last_selected_file_name.length()
		
			
func update_selected_file_nums_label(nums):
	selected_file_nums = nums
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


func _on_DraggableFileDialog_hide():
	show_other_controls()

# 자세히 보기 
func _on_DetailViewButton_toggled(_button_pressed):
	set_grid_columns()
	update_lsit()

func resize():
	if visible:
		popup_centered()

func _on_SortByNameButton_pressed():
	if sort_by_name_button.pressed:
		sort_method = Sort.by_name
	else:
		sort_method = Sort.by_name_r
	update_lsit()
	

func _on_SortByDateButton_pressed():
	if sort_by_date_button.pressed:
		sort_method = Sort.by_date
	else:
		sort_method = Sort.by_date_r
	update_lsit()


# photo를 누르면 godot get image plugin을 통해서 이미지 가져오기를 실행한다.
func _on_PhotoButton_pressed():
	var godot_get_image = PluginManager.get_godot_get_image()
	if godot_get_image != null:
		godot_get_image.getGalleryImage()
	

# photo에서 이미지 가져오기를 성공하면..
# 이미지 파일로 저장하고 file dialog를 닫는다.
func _on_image_request_completed(dict):
	for img_buffer in dict.values():
		var image = Image.new()
		var error = image.load_jpg_from_buffer(img_buffer)
		if error != OK:
			Util.show_error_message(self, error)
		else:
			yield(get_tree(), "idle_frame")
			var file_path = OS.get_user_data_dir() + "/brpixel_get_image_from_gallery_____.png" 
			image.save_png(file_path)
			selected_file_nums = 1
			selected_file_paths.append(file_path)
			result_ok = true
			hide()
			break
			
