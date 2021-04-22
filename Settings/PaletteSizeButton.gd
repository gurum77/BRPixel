extends Button


export var size = 50


func _draw():
	var x = rect_size.x / 2 - size/2
	var y = x
	var rect = Rect2(x, y, size, size)
	draw_rect(rect, Color.yellowgreen, true)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	update()


func _on_PaletteSizeButton_pressed():
	StaticData.palette_size = size
	NodeManager.get_color_panel().load_current_palette()

