extends TextureButton


onready var my_color_picker = get_parent()
onready var color_info = get_node("ColorInfo")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	self_modulate = my_color_picker.get_selected_color()
	color_info.text = "%d,%d,%d" % [self_modulate.r8, self_modulate.g8, self_modulate.b8]
	if Util.is_black_text(self_modulate):
		color_info.modulate = Color.black
	else:
		color_info.modulate = Color.white

	


func _on_SelectedColorButton_pressed():
	$Controller.popup()
