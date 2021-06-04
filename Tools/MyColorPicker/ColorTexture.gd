extends TextureRect


func _draw():
	var rect = Rect2(0, 0, rect_size.x, rect_size.y)
	draw_rect(rect, modulate)
