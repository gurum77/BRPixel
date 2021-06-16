extends TextureRectButton
class_name PickColorFromCanvasButton
var pickcolor_tool = preload("res://Tools/PickColorFromCanvas.tscn")
	
func _ready():
	Util.set_tooltip(self, "Eyedropper Circle tool", "I")
	
func _on_PickColorFromCanvasButton_pressed():
	run()
	
func run():
	NodeManager.get_tools().add_child(pickcolor_tool.instance())

func _process(_delta):
	Util.press_current_tool_button(self, StaticData.Tool.pick_color_from_canvas)
		


func _on_PickColorFromCanvasButton_gui_input(event):
	run_gui_input(event)
	pass # Replace with function body.
