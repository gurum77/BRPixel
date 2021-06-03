extends VBoxContainer


enum valueType{R,G,B}
export (valueType) var value_type = valueType.R
var my_color_picker:MyColorPicker = null

onready var color_value_line_edit = get_node_or_null("HBoxContainer/ColorValueLineEdit")
onready var hslider = get_node_or_null("HBoxContainer/HSlider")

func get_value_type_text()->String:
	if value_type == valueType.R:
		return "R"
	elif value_type == valueType.G:
		return "G"
	elif value_type == valueType.B:
		return "B"
	elif value_type == valueType.A:
		return "A"
	return ""
		
# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/ColorValueTextLabel.text = get_value_type_text()
	
func get_selected_color()->Color:
	if my_color_picker == null:
		return Color.white
	return my_color_picker.get_selected_color()
	
func set_selected_color(col):
	if my_color_picker == null:
		return
	my_color_picker.set_selected_color(col)
	
func set_selected_color8_value(color8_value):
	var color = get_selected_color()
	if value_type == valueType.R:
		color.r8 = color8_value
	elif value_type == valueType.G:
		color.g8 = color8_value
	elif value_type == valueType.B:
		color.b8 = color8_value
	elif value_type == valueType.A:
		color.a8 = color8_value
	set_selected_color(color)
	
func get_selected_color8_value()->int:
	if value_type == valueType.R:
		return get_selected_color().r8
	elif value_type == valueType.G:
		return get_selected_color().g8
	elif value_type == valueType.B:
		return get_selected_color().b8
	elif value_type == valueType.A:
		return get_selected_color().a8
	return 0
	
func _process(delta):
	if color_value_line_edit != null:
		color_value_line_edit.text = str(get_selected_color8_value())
	if hslider != null:
		hslider.value = get_selected_color8_value()




func _on_ColorValueLineEdit_text_changed(new_text:String):
	var value = new_text.to_int()
	if value >= 0 && value <= 255:
		set_selected_color8_value(value)
		
		
