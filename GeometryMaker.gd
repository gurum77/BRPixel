extends Node

static func to_1D(x, y, w) -> int:
	return x + y * w


static func to_2D(idx, w) -> Vector2:
	var p = Vector2()
	p.x = int(idx) % int(w)
	p.y = int(idx / w)
	return p 
	
# 두점 사이의 사각형에 대한 pixel을 만들어서 리턴
static func get_pixels_in_rectangle(from:Vector2, to:Vector2)->Array:
	# 가로선들 
	var hor1 = get_pixels_in_line(Vector2(from.x, to.y), to)
	var hor2 = get_pixels_in_line(from, Vector2(to.x, from.y))
	var vert1 = get_pixels_in_line(from, Vector2(from.x, to.y))
	var vert2 = get_pixels_in_line(Vector2(to.x, from.y), to)
	var points : Array = []
	
	for p in hor1:
		points.append(p)
	for p in hor2:
		points.append(p)
	for p in vert1:
		points.append(p)
	for p in vert2:
		points.append(p)
	return points
	
# 두점 사이의 선에 대한 pixel을 만들어서 리턴
static func get_pixels_in_line(from: Vector2, to: Vector2)->Array:
	var x1:int = from.x
	var y1:int = from.y
	var x2:int = to.x
	var y2:int = to.y
	
	var points : Array = []
	var dx:int = x2 - x1
	var dy:int = y2 - y1
	var offset:int = 1
	
	if abs(dx) > abs(dy):	
		if x2 < x1:
			offset = -1
		for x in range(x1, x2, offset):
			var y = y1 + dy * (x - x1) / dx
			points.append(Vector2(x, y))
	else:
		if y2 < y1:
			offset = -1
		for y in range(y1, y2, offset):
			var x = x1 + dx * (y - y1) / dy
			points.append(Vector2(x, y))
			
	# 마지막점 추가
	points.append(to)
	
	return points
