extends TextureRect

export var cols = 1

func _draw():
	var x = 0
	var w = rect_size.x / cols
	
	for col in cols:
		var rect:Rect2 = Rect2(x, 0, w, rect_size.y)
		draw_rect(rect, Color.blue, false)
		x = x + w
	pass
