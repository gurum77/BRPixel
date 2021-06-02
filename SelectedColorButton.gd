extends TextureButton


onready var last_color_selector = get_parent().get_node("LastColorSelector")
onready var color_info = get_node("ColorInfo")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	self_modulate = last_color_selector.get_selected_color()
	color_info.text = "%d,%d,%d" % [self_modulate.r8, self_modulate.g8, self_modulate.b8]
	if is_black_text():
		color_info.modulate = Color.black
	else:
		color_info.modulate = Color.white
func is_black_text()->bool:
	if self_modulate.r > 0.5:
		return true
	if self_modulate.g > 0.5:
		return true
	if self_modulate.b > 0.5:
		return true
	return false
	
	


func _on_SelectedColorButton_pressed():
	$Controller.popup_centered()
