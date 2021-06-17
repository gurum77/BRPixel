extends Button
class_name SymmetryButton

export (StaticData.SymmetryType) var symmetry_type

func _ready():
	if symmetry_type == StaticData.SymmetryType.no:
		Util.set_tooltip(self, tr("No symmetry"), "")
	elif symmetry_type == StaticData.SymmetryType.vertical:
		Util.set_tooltip(self, tr("Vertical symmetry"), "")
	elif symmetry_type == StaticData.SymmetryType.horizontal:
		Util.set_tooltip(self, tr("Horizontal symmetry"), "")

func _on_SymmetryButton_pressed():
	run()
	
func run():
	StaticData.symmetry_type = symmetry_type
	NodeManager.get_symmetry_grips().update_canvas_and_grips()
		
func _process(_delta):
	var need_to_pressed = StaticData.symmetry_type == symmetry_type
	if pressed != need_to_pressed:
		pressed = need_to_pressed
	
