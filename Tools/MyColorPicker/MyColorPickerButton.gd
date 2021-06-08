extends Button
class_name MyColorPickerButton
signal color_changed(color)
export (Color) var selected_color = Color.white

var my_color_picker_node = preload("res://Tools/MyColorPicker/MyColorPicker.tscn")
var background_panel_node = preload("res://Tools/MyColorPicker/BackgroundPanel.tscn")

onready var color_texture = $ColorTexture
onready var add_to_palette_button = $AddToPaletteButton

var my_color_picker:MyColorPicker = null
var background_panel:BackgroundPanel = null


# Called when the node enters the scene tree for the first time.
func _ready():
	update()
	# add to palette button은 처음에는 안보이게 한다.
	add_to_palette_button.visible = false
	add_to_palette_button.hint_tooltip = "Add color to palette"
	

func get_root_canvas_layer()->CanvasLayer:
	var cl = get_tree().root.get_node_or_null("RootCanvasLayer")
	if cl == null:
		cl = CanvasLayer.new()
		get_tree().root.add_child(cl)
	return cl
		

func _on_MyColorPickerButton_pressed():
	if background_panel == null:
		background_panel = background_panel_node.instance()
		get_root_canvas_layer().add_child(background_panel)
		var _res = background_panel.connect("pressed", self, "_on_BackgroundPanel_pressed")
	background_panel.visible = true
	
	
	if my_color_picker == null:
		my_color_picker = my_color_picker_node.instance()
		get_root_canvas_layer().add_child(my_color_picker)
		var _res = my_color_picker.connect("color_changed", self, "_on_MyColorPicker_color_changed")
	my_color_picker.set_selected_color(selected_color)
	my_color_picker.reposition_selectors()
	my_color_picker.visible = true
	my_color_picker.popup_centered()# .rect_position = rect_position + Vector2(rect_size.x, 0)



func _on_BackgroundPanel_pressed():
	background_panel.visible = false
	my_color_picker.visible = false

func change_selected_color(color):
	set_selected_color(color)
	emit_signal("color_changed", selected_color)
	
func set_selected_color(color):
	selected_color = color
	color_texture.modulate = selected_color
	color_texture.update()
	update_add_to_palette_button()
	
	
func update_add_to_palette_button():
	var palette = NodeManager.get_current_palette()
	if palette != null:
		add_to_palette_button.visible = !palette.colors.has(selected_color)
		
# 색이 바뀌면 호출된다.
func _on_MyColorPicker_color_changed(color):
	change_selected_color(color)
	
	

# 현재 팔레트에 이 색을 추가한다.
func _on_AddToPaletteButton_pressed():
	var palette = NodeManager.get_current_palette()
	if palette != null:
		palette.colors.append(selected_color)
		NodeManager.get_color_panel().load_current_palette()
		update_add_to_palette_button()
		NodeManager.get_color_panel().scroll_color_buttons_to_current_color()
		
