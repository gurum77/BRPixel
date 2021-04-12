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


func _on_TileModeButton_pressed():
	StaticData.enabled_tilemode = !StaticData.enabled_tilemode
	var tiles:Tiles = NodeManager.get_tiles()
	tiles.init_size_tiles()
	tiles.visible = StaticData.enabled_tilemode
	
