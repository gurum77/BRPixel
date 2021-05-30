extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# project name은 번역하면 안됨
	$DraggablePopup/HBoxContainer/ProjectNameLabel.set_message_translation(false)
	# 포커스는 클릭할 때만 들어가게 해야함
	$DraggablePopup/HBoxContainer/ProjectNameLabel.focus_mode = Control.FOCUS_CLICK

	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func hide():
	$DraggablePopup.hide()
	
func popup_centered():
	$DraggablePopup.popup_centered()
	update_controls()
	
func update_controls():
	$DraggablePopup/HBoxContainer/ProjectNameLabel.text = StaticData.project_name
	$DraggablePopup/VBoxContainer/VersionLabel.text = get_version_text()
	
func get_version_text()->String:
	return "Version %.1f(made by Godot 3.3)" % [Define.version]
	
	
# canvas size button
func _on_CanvasSizeButton_pressed():
	$DraggablePopup/GridContainer/CanvasSizeButton/CanvasSizePopup.popup_centered()


# new button
func _on_NewButton_pressed():
	$DraggablePopup/GridContainer/NewButton/NewPopup.popup_centered()


# language button
func _on_LanguageButton_pressed():
	$DraggablePopup/GridContainer/LanguageButton/LanguagePopup.popup_centered()

# 프로젝트 이름 변경
func _on_ProjectNameLabel_text_changed(new_text):
	StaticData.project_name = new_text




func _on_HomeButton_pressed():
	var _result = OS.shell_open("https://blog.naver.com/hileejaeho/222357691687")


func _on_EmailButton_pressed():
	var _result = OS.shell_open("mailto:hileejaeho@gmail.com")


func _on_DownloadAndroidAppButton_pressed():
	var _result = OS.shell_open("https://play.google.com/store/apps/details?id=com.br.brpixel")


func _on_DownloadFromNaver_pressed():
	var _result = OS.shell_open("https://software.naver.com/software/summary.nhn?softwareId=GWS_003514")


func _on_DownloadFromOneStore_pressed():
	var _result = OS.shell_open("https://onesto.re/00756006")
