extends Control
class_name ColorSettingPopup

var color_index:int = 0
var palette:Palette
func popup_centered():
	$DraggablePopup.popup_centered()
	
	palette = NodeManager.get_current_palette()
	if palette.colors.size() <= color_index:
		hide()
		return
		
	update_color_picker_button()
	
func update_color_picker_button():
	$DraggablePopup/GridContainer/ColorPickerButton.set_selected_color(palette.colors[color_index])
	
func hide():
	$DraggablePopup.hide()

func _on_DuplicateButton_pressed():
	var new_color = palette.colors[color_index]
	palette.colors.append(new_color)
	NodeManager.get_color_panel().load_current_palette()
	
	
func _on_DarkenButton_pressed():
	change_current_color(palette.colors[color_index].darkened(0.1))


func _on_BrightenButton_pressed():
	change_current_color(palette.colors[color_index].lightened(0.1))
	
func change_current_color(color):
	if palette == null:
		return
	palette.colors[color_index] = color
	update_color_picker_button()
	NodeManager.get_color_panel().update_color_button(color_index)
	StaticData.current_color = color
	
func _on_ToUpButton_pressed():
	# 첫번째 색이면 위로 못 올림
	if color_index == 0:
		return
	
	var prev_color = palette.colors[color_index-1]
	var current_color = palette.colors[color_index]
	palette.colors[color_index] = prev_color
	palette.colors[color_index-1] = current_color
	color_index = color_index - 1
	NodeManager.get_color_panel().load_current_palette()
	
func _on_ToDownButton_pressed():
	# 마지막 색이면 아래로 못 내림
	if color_index == palette.colors.size()-1:
		return
	var current_color = palette.colors[color_index]
	var next_color = palette.colors[color_index+1]
	palette.colors[color_index] = next_color
	palette.colors[color_index+1] = current_color
	color_index = color_index + 1
	NodeManager.get_color_panel().load_current_palette()

# 색 변경
func _on_ColorPickerButton_color_changed(color):
	change_current_color(color)
	
