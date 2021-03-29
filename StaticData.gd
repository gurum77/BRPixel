extends Node

enum Tool{pencil, line, rectangle, eraser, fill, change_color, circle, select}

var current_tool = Tool.pencil
var current_color = Color.black
var current_palette = null
var current_layer = null
var preview_layer = null

var mouse_inside_ui:bool = false

var canvas_width = 64
var canvas_height = 64

# mosue 좌표가 tool에 적용하기에 부적합한지?
func invalid_mouse_pos_for_tool(tool_type)->bool:
	# mouse가 ui에 있으면 false
	if StaticData.mouse_inside_ui:
		return true
		
	# 같은 tool이 아니면 false
	if StaticData.current_tool != tool_type:
		return true
		
	
		
	return false
		
func _ready():
	pass
	
