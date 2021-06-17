extends LineEdit
class_name MyLineEdit

func _ready():
	connect("focus_entered", self, "_on_focus_entered")
	connect("focus_exited", self, "_on_focus_exited")

func _on_focus_entered():
	InputManager.text_editing = true
func _on_focus_exited():
	InputManager.text_editing = false

func _is_pos_in(checkpos:Vector2):
	var gr = get_global_rect()
	return checkpos.x>=gr.position.x and checkpos.y>=gr.position.y and 	checkpos.x<gr.end.x and checkpos.y<gr.end.y

func _input(event):
	if event is InputEventMouseButton and not _is_pos_in(event.position):
		release_focus()
