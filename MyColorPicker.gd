extends Panel

class_name MyColorPicker

export (Color) var selected_color = Color.red	

func get_selected_color()->Color:
	return selected_color
	
# 현재 색을 지정해서 first color selectr와 last color select의 x / y 값을 정한다.
func set_selected_color(color):
	selected_color = color
	pass
	
	
func _ready():
	$SelectedColorButton/Controller/VBoxContainer/RValueSlider.my_color_picker = self
	$SelectedColorButton/Controller/VBoxContainer/GValueSlider.my_color_picker = self
	$SelectedColorButton/Controller/VBoxContainer/BValueSlider.my_color_picker = self
	$SelectedColorButton/Controller/VBoxContainer/AValueSlider.my_color_picker = self
