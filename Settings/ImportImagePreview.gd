extends TextureRect

export var cols = 1
export var rows = 1

func _draw():
	# 이미지가 더 작으면 이미지의 크기를 준다.
	var width = rect_size.x
	var height = rect_size.y
	
	var rects = Util.get_rects(rect_size.x, rect_size.y, rows, cols)
	for rect in rects:
		draw_rect(rect, Color.blue, false)
