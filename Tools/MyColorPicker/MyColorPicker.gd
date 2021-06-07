extends Panel

signal color_changed(color)

class_name MyColorPicker

export (Color) var selected_color = Color.red	

onready var rvalue_slider = $SelectedColorButton/Controller/VBoxContainer/RValueSlider
onready var gvalue_slider = $SelectedColorButton/Controller/VBoxContainer/GValueSlider
onready var bvalue_slider = $SelectedColorButton/Controller/VBoxContainer/BValueSlider
onready var avalue_slider = $SelectedColorButton/Controller/VBoxContainer/AValueSlider
onready var hvalue_slider = $SelectedColorButton/Controller/VBoxContainer/HValueSlider
onready var svalue_slider = $SelectedColorButton/Controller/VBoxContainer/SValueSlider
onready var vvalue_slider = $SelectedColorButton/Controller/VBoxContainer/VValueSlider
onready var color_line_edit = $SelectedColorButton/Controller/VBoxContainer/HBoxContainer/ColorLineEdit
onready var controller = $SelectedColorButton/Controller
	
func get_selected_color()->Color:
	return selected_color
	
func change_selected_color(color):
	set_selected_color(color)
	emit_signal("color_changed", color)

# 가운데에 표시
func popup_centered():
	var size = get_viewport_rect().size
	var width = size.x #ProjectSettings.get("display/window/size/width")
	var height = size.y #ProjectSettings.get("display/window/size/height")
	
	var control_width = rect_size.x
	if controller != null && controller.visible:
		control_width = controller.rect_size.x
		
	rect_global_position.x = width / 2 - control_width / 2
	rect_global_position.y = height / 2 - rect_size.y
	
# 현재 색을 지정해서 first color selectr와 last color select의 x / y 값을 정한다.
func set_selected_color(color):
	selected_color = color
	
	
func _ready():
	rvalue_slider.my_color_picker = self
	gvalue_slider.my_color_picker = self
	bvalue_slider.my_color_picker = self
	avalue_slider.my_color_picker = self
	hvalue_slider.my_color_picker = self
	svalue_slider.my_color_picker = self
	vvalue_slider.my_color_picker = self
	color_line_edit.my_color_picker = self
	
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


func _on_ColorLineEdit_focus_exited():
	pass # Replace with function body.
