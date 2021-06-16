extends Button
class_name SelectButton

func _ready():
	Util.set_tooltip(self, "Selection tool", "S")


func _on_SelectButton_pressed():
	run()
func run():
	NodeManager.get_tools().add_child(NodeManager.get_tools().select_tool.instance())

func _process(_delta):
	Util.press_current_tool_button(self, StaticData.Tool.select)
