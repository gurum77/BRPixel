extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# 안드로이드에서만 보인다.
	if OS.get_name() == "Android":
		visible = true
	else:
		visible = false

func _on_PhotoButton_pressed():
	pass # Replace with function body.
