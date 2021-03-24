extends Node

static func to_1D(x, y, w) -> int:
	return x + y * w


static func to_2D(idx, w) -> Vector2:
	var p = Vector2()
	p.x = int(idx) % int(w)
	p.y = int(idx / w)
	return p 
	
# 두 점 사이의 circle에 대한 pixel을 만들어서 리턴
static func get_pixels_in_circle(from:Vector2, to:Vector2)->Array:
	var pixels:Array
	
	var rx:int = abs((from.x - to.x)/2)
	var ry:int = abs((from.y - to.y)/2)
	var xc:int = abs((from.x + to.x)/2)
	var yc:int = abs((from.y + to.y)/2)
	
	var dx:float
	var dy:float
	var d1:float
	var d2:float
	var x:float
	var y:float
	x = 0
	y = ry
  
	# Initial decision parameter of region 1
	d1 = (ry * ry) - (rx * rx * ry) + (0.25 * rx * rx)
	dx = 2 * ry * ry * x
	dy = 2 * rx * rx * y
  
	# For region 1
	while dx < dy:
		# Print points based on 4-way symmetry
		pixels.append(Vector2(x + xc, y + yc))
		pixels.append(Vector2(-x + xc, y + yc))
		pixels.append(Vector2(x + xc, -y + yc))
		pixels.append(Vector2(-x + xc, -y + yc))
		
		# Checking and updating value of
		# decision parameter based on algorithm
		if d1 < 0:
			x += 1
			dx = dx + (2 * ry * ry)
			d1 = d1 + dx + (ry * ry)
		else :
			x += 1
			y -= 1
			dx = dx + (2 * ry * ry)
			dy = dy - (2 * rx * rx)
			d1 = d1 + dx - dy + (ry * ry)
  
	# Decision parameter of region 2
	d2 = ((ry * ry) * ((x + 0.5) * (x + 0.5))) + ((rx * rx) * ((y - 1) * (y - 1))) - (rx * rx * ry * ry)
  
	# Plotting points of region 2
	while y >= 0:
		# Print points based on 4-way symmetry
		pixels.append(Vector2(x + xc, y + yc))
		pixels.append(Vector2(-x + xc, y + yc))
		pixels.append(Vector2(x + xc, -y + yc))
		pixels.append(Vector2(-x + xc, -y + yc))
  
		# Checking and updating parameter
		# value based on algorithm
		if d2 > 0:
			y -= 1
			dy = dy - (2 * rx * rx)
			d2 = d2 + (rx * rx) - dy
		else:
			y -= 1
			x += 1
			dx = dx + (2 * ry * ry)
			dy = dy - (2 * rx * rx)
			d2 = d2 + dx - dy + (rx * rx)
	return pixels
	
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
			var pos = Vector2(x, y)
			if StaticData.current_layer.has_point(pos):
				points.append(pos)
	else:
		if y2 < y1:
			offset = -1
		for y in range(y1, y2, offset):
			var x = x1 + dx * (y - y1) / dy
			var pos = Vector2(x, y)
			if StaticData.current_layer.has_point(pos):
				points.append(pos)
			
	# 마지막점 추가
	if StaticData.current_layer.has_point(to):
		points.append(to)
	
	return points
