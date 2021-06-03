extends VBoxContainer


enum valueType{R,G,B,A,H,S,V}
export (valueType) var value_type = valueType.R
var my_color_picker = null
var is_focus_entered_line_edit = false
onready var color_value_line_edit = get_node_or_null("HBoxContainer/ColorValueLineEdit")
onready var hslider = get_node_or_null("HBoxContainer/HSlider")

func get_max_value():
	if value_type == valueType.H:
		return 360
	elif value_type == valueType.S:
		return 100
	elif value_type == valueType.V:
		return 100		
	return 255
	
func get_value_type_text()->String:
	if value_type == valueType.R:
		return "R"
	elif value_type == valueType.G:
		return "G"
	elif value_type == valueType.B:
		return "B"
	elif value_type == valueType.A:
		return "A"
	elif value_type == valueType.H:
		return "H"
	elif value_type == valueType.S:
		return "S"
	elif value_type == valueType.V:
		return "V"
	return ""
		
# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/ColorValueTextLabel.text = get_value_type_text()
	$HBoxContainer/HSlider.max_value = get_max_value()
	
func get_selected_color()->Color:
	if my_color_picker == null:
		return Color.white
	return my_color_picker.get_selected_color()
	
func set_selected_color(col):
	if my_color_picker == null:
		return
	my_color_picker.set_selected_color(col)
	my_color_picker.reposition_selectors()
	
func set_selected_color8_value(color8_value):
	var color:Color = get_selected_color()
	if value_type == valueType.R:
		color.r8 = color8_value
	elif value_type == valueType.G:
		color.g8 = color8_value
	elif value_type == valueType.B:
		color.b8 = color8_value
	elif value_type == valueType.A:
		color.a8 = color8_value
	elif value_type == valueType.H:
		if color8_value == 0:
			color.h = 0
		else:
			color.h = color8_value / 360.0
	elif value_type == valueType.S:
		if color8_value == 0:
			color.s = 0
		else:
			color.s = color8_value / 100.0
	elif value_type == valueType.V:
		if color8_value == 0:
			color.v = 0
		else:
			color.v = color8_value / 100.0
	set_selected_color(color)
	
func get_selected_color8_value()->int:
	var selected_color = get_selected_color()
	if value_type == valueType.R:
		return selected_color.r8
	elif value_type == valueType.G:
		return selected_color.g8
	elif value_type == valueType.B:
		return selected_color.b8
	elif value_type == valueType.A:
		return selected_color.a8
	elif value_type == valueType.H:
		return (selected_color.h * 360.0) as int
	elif value_type == valueType.S:
		return (selected_color.s * 100.0) as int
	elif value_type == valueType.V:
		return (selected_color.v * 100.0) as int
	return 0
	
func _process(delta):
	if visible:
		if color_value_line_edit != null && !is_focus_entered_line_edit:
			color_value_line_edit.text = str(get_selected_color8_value())
		if hslider != null:
			hslider.value = get_selected_color8_value()




func _on_ColorValueLineEdit_text_changed(new_text:String):
	var value = new_text.to_int()
	if value >= 0 && value <= get_max_value():
		set_selected_color8_value(value)
		
func _on_HSlider_value_changed(value):
	if value >= 0 && value <= get_max_value():
		set_selected_color8_value(value)


func _on_ColorValueLineEdit_focus_entered():
	is_focus_entered_line_edit = true


func _on_ColorValueLineEdit_focus_exited():
	is_focus_entered_line_edit = false
