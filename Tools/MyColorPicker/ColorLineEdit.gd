extends MyLineEdit

var my_color_picker:MyColorPicker = null
var focused = true

func _process(_delta):
	if my_color_picker == null:
		return
	if focused:
		return

	var color = my_color_picker.get_selected_color()
	text = color.to_html()
	


func _on_ColorLineEdit_focus_entered():
	focused = true


func _on_ColorLineEdit_focus_exited():
	focused = false


func _on_ColorLineEdit_text_changed(new_text):
	if my_color_picker == null:
		return
	
	my_color_picker.set_selected_color(Color(new_text))
