extends Node

var version:float = 0.1
var min_canvas_size:int = 1
var max_canvas_size:int = 1024
var max_clipboard_count:int = 3	# clipboard 최대 갯수

var min_thickness:int = 1
var max_thickness:int = 10

var min_delay_per_frame = 0.001
var max_delay_per_frame = 10

var darker_amount = 0.1
var brighter_amount = 0.2

var fileThumbnailTexture:StreamTexture = preload("res://Assets/icon_file.png")
var directoryThumbnailTexture:StreamTexture = preload("res://Assets/icon_directory.png")
var languageTexture:StreamTexture = preload("res://Assets/icon_language.png")

# 자동 저장된 project file
var auto_saved_project_file:String="user://auto_save.pex"
