extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# 선택한 영역을 지운다.
func _on_DeleteButton_pressed():
	if !StaticData.enabled_selected_area():
		return
	var points = GeometryMaker.get_pixels_in_rectangle(StaticData.selected_area.position, StaticData.selected_area.end)
	StaticData.current_layer.erase_pixels(points)
