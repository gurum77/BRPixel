extends MenuButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_popup().add_item("Pattern aligned to source")
	get_popup().add_item("Pattern aligned to destination")
	get_popup().add_item("Paint brush")
	get_popup().set_item_as_radio_checkable(0, true)
	get_popup().set_item_as_radio_checkable(1, true)
	get_popup().set_item_as_radio_checkable(2, true)
	update_menu_button_text()
	var _res = get_popup().connect("id_pressed", self, "_on_UserBrushPatternMenuButton_id_pressed")

func _process(_delta):
	visible = StaticData.brush_type == StaticData.BrushType.User
	
func update_menu_button_text():
	text = get_popup().get_item_text(StaticData.user_brush_pattern as int)


func _on_UserBrushPatternMenuButton_id_pressed(id):
	StaticData.user_brush_pattern = id
	update_menu_button_text()
