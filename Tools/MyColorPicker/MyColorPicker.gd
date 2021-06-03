extends Panel

class_name MyColorPicker

export (Color) var selected_color = Color.red	

onready var rvalue_slider = $SelectedColorButton/Controller/VBoxContainer/RValueSlider
onready var gvalue_slider = $SelectedColorButton/Controller/VBoxContainer/GValueSlider
onready var bvalue_slider = $SelectedColorButton/Controller/VBoxContainer/BValueSlider
onready var avalue_slider = $SelectedColorButton/Controller/VBoxContainer/AValueSlider
onready var hvalue_slider = $SelectedColorButton/Controller/VBoxContainer/HValueSlider
onready var svalue_slider = $SelectedColorButton/Controller/VBoxContainer/SValueSlider
onready var vvalue_slider = $SelectedColorButton/Controller/VBoxContainer/VValueSlider

	
func get_selected_color()->Color:
	return selected_color
	
# 현재 색을 지정해서 first color selectr와 last color select의 x / y 값을 정한다.
func set_selected_color(color):
	selected_color = color
	pass
	
	
func _ready():
	rvalue_slider.my_color_picker = self
	gvalue_slider.my_color_picker = self
	bvalue_slider.my_color_picker = self
	avalue_slider.my_color_picker = self
	hvalue_slider.my_color_picker = self
	svalue_slider.my_color_picker = self
	vvalue_slider.my_color_picker = self
	
	
	reposition_selectors()

func reposition_selectors():
	$FirstColorSelector.reposition_selected_x()
	$LastColorSelector.update()
	$LastColorSelector.reposition_selected_xy()


func _on_Tabs_tab_changed(tab):
	# rgb
	if tab == 0:
		rvalue_slider.visible = true
		gvalue_slider.visible = true
		bvalue_slider.visible = true
		avalue_slider.visible = true
		
		hvalue_slider.visible = false
		svalue_slider.visible = false
		vvalue_slider.visible = false
	elif tab == 1:
		rvalue_slider.visible = false
		gvalue_slider.visible = false
		bvalue_slider.visible = false
		avalue_slider.visible = true
		
		hvalue_slider.visible = true
		svalue_slider.visible = true
		vvalue_slider.visible = true
