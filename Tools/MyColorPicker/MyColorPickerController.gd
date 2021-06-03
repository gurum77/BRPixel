extends DraggableWindow



# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/HBoxContainer/Tabs.add_tab("RGB")
	$VBoxContainer/HBoxContainer/Tabs.add_tab("HSV")


