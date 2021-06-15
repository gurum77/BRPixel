extends Node



static func to_1D(x, y, w) -> int:
	return x + y * w


static func to_2D(idx, w) -> Vector2:
	var p = Vector2()
	p.x = int(idx) % int(w)
	p.y = int(idx / w)
	return p 
	
# point에 user brush 를 반영해서 리턴한다.
static func get_pixel_with_colors_by_current_user_brush(points:Array)->Dictionary:
	var pixel_with_colors = Dictionary()
	
	var _image = StaticData.current_user_brush_texture.get_data()
	if _image == null:
		return pixel_with_colors
		
	_image.lock()
	var w = _image.get_width()
	var h = _image.get_height()
	var center = Vector2(floor(w/2), floor(h/2))
	
	var origin_point = StaticData.current_user_brush_origin_point - center
	if StaticData.user_brush_pattern == StaticData.UserBrushPattern.aligned_to_destination:
		origin_point = StaticData.current_user_brush_destination_point - center
	for point in points:
		for x in w:
			# 좌표가 찍히는 실제 위치
			var new_point_x = point.x + x - center.x
			var image_x = x
			if StaticData.user_brush_pattern != StaticData.UserBrushPattern.paint:
				# 이미의 x 좌표
				var offset_x = new_point_x - origin_point.x
				image_x = offset_x - floor(offset_x / w) * w
				if image_x < 0:
					image_x = w - image_x
			for y in h:
				var new_point_y = point.y + y - center.y
				var image_y = y
				if StaticData.user_brush_pattern != StaticData.UserBrushPattern.paint:
					image_y = new_point_y - floor(new_point_y / h) * h
				
				var color = _image.get_pixel(image_x, image_y)
				pixel_with_colors[Vector2(new_point_x, new_point_y)] = color
				
	_image.unlock()	
	return pixel_with_colors
	
# point로 brush type을 반영한 pixel을 리턴한다.
static func get_pixel_with_colors_by_brush_type(var points)->Dictionary:
	if StaticData.brush_type != StaticData.BrushType.User:
		var pixels = Dictionary()
		for point in points:
			pixels[point] = StaticData.current_color
		return pixels
	else:
		return GeometryMaker.get_pixel_with_colors_by_current_user_brush(points)
		
# ortho로 end point를 보정해서 리턴한다.
static func get_end_point_by_orthomode(var from, var to)->Vector2:
	if !StaticData.enabled_orthomode:
		return to
		
	
	var vec:Vector2 = to - from
	vec = vec.normalized()

	var dist = from.distance_to(to)
	var offset_angle = 22.5
	var ang = rad2deg(vec.angle())
	var new_ang = round(ang / offset_angle) * offset_angle
	new_ang = deg2rad(new_ang)
	var new_dir = Vector2(cos(new_ang), sin(new_ang)).normalized()
	
	to = from + new_dir * dist
	return to
	
# pixel를 start 부터 offset간격으로 가져온다.
func get_pixels_by_check_pattern(pixels, first:bool)->Array:
	var start = 0
	if !first:
		start = 1
	var offset_pixels = []
	for pixel in pixels:
		var x:int = floor(pixel.x) as int
		var y:int = floor(pixel.y) as int
		var result_x = x % 2
		var result_y = y % 2
		
		if result_y == 0:
			if result_x == start:
				offset_pixels.append(pixel)
		else:
			if result_x != start:
				offset_pixels.append(pixel)
			
	return offset_pixels
	
# 원점 기준 채워진 ellipse의 points를 계산
func _get_ellipse_points_filled_on_origin(size: Vector2, thickness:int) -> PoolVector2Array:
	var offseted_size := size + Vector2(2, 2) * (thickness - 1)
	var border := _get_ellipse_points(Vector2.ZERO, offseted_size)
	var filling := []
	var bitmap := _fill_bitmap_with_points(border, offseted_size)

	for x in range(1, ceil(offseted_size.x / 2)):
		var fill := false
		var prev_is_true := false
		for y in range(0, ceil(offseted_size.y / 2)):
			var top_l_p := Vector2(x, y)
			var bit := bitmap.get_bit(top_l_p)

			if bit and not fill:
				prev_is_true = true
				continue

			if not bit and (fill or prev_is_true):
				filling.append(GeometryMaker.get_adjusted_point_by_tile_mode(top_l_p))
				filling.append(GeometryMaker.get_adjusted_point_by_tile_mode(Vector2(x, offseted_size.y - y - 1)))
				filling.append(GeometryMaker.get_adjusted_point_by_tile_mode(Vector2(offseted_size.x - x - 1, y)))
				filling.append(GeometryMaker.get_adjusted_point_by_tile_mode(Vector2(offseted_size.x - x - 1, offseted_size.y - y - 1)))

				if prev_is_true:
					fill = true
					prev_is_true = false
			elif bit and fill:
				break

	return PoolVector2Array(border + filling)

# 원점 기준 ellipse 포인트를 계산
func _get_ellipse_points_on_origin(size: Vector2, thickness:int) -> PoolVector2Array:
	# Return ellipse with thickness 1
	if thickness == 1:
		return PoolVector2Array(_get_ellipse_points(Vector2.ZERO, size))

	var size_offset := Vector2.ONE * 2 * (thickness - 1)
	var new_size := size + size_offset
	var inner_ellipse_size = new_size - 2 * size_offset

	# The inner ellipse is to small to create a gap in the middle of the ellipse, just return a filled ellipse
	if inner_ellipse_size.x <= 2 and inner_ellipse_size.y <= 2:
		return _get_ellipse_points_filled_on_origin(size, thickness)

	# Adapted scanline algorithm to fill between 2 ellipses, to create a thicker ellipse
	var res_array := []
	var border_ellipses :=  _get_ellipse_points(Vector2.ZERO, new_size) + _get_ellipse_points(size_offset, inner_ellipse_size) # Outer and inner ellipses
	var bitmap := _fill_bitmap_with_points(border_ellipses, new_size)
	var smallest_side := min (new_size.x, new_size.y)
	var largest_side := max (new_size.x, new_size.y)
	var scan_dir := Vector2(0, 1) if smallest_side == new_size.x else Vector2(1,0)
	var iscan_dir := Vector2(1, 0) if smallest_side == new_size.x else Vector2(0,1)
	var ie_relevant_offset_side = size_offset.x if smallest_side == new_size.x else size_offset.y
	var h_ls_c := ceil(largest_side / 2)

	for s in range(ceil(smallest_side / 2)):
		if s <= ie_relevant_offset_side:
			var draw := false
			for l in range(h_ls_c):
				var pos := scan_dir * l + iscan_dir * s
				if bitmap.get_bit(pos):
					draw = true
				if draw:
					var mirror_smallest_side := iscan_dir * (smallest_side - 1 - 2 * s)
					var mirror_largest_side := scan_dir * (largest_side - 1 - 2 * l)
					res_array.append(pos)
					res_array.append(pos + mirror_largest_side)
					res_array.append(pos + mirror_smallest_side)
					res_array.append(pos + mirror_smallest_side + mirror_largest_side)
		else:
			# Find outer ellipse
			var l_o := 0
			for l in range (h_ls_c):
				var pos := scan_dir * l + iscan_dir * s
				if bitmap.get_bit(pos):
					l_o = l
					break
			# Find inner ellipse
			var li := 0
			for l in range(h_ls_c, 0, -1):
				var pos := scan_dir * l + iscan_dir * s
				if bitmap.get_bit(pos):
					li = l
					break
			# Fill between both
			for l in range(l_o, li + 1):
				var pos := scan_dir * l + iscan_dir * s
				var mirror_smallest_side := iscan_dir * (smallest_side - 1 - 2 * s)
				var mirror_largest_side := scan_dir * (largest_side - 1 - 2 * l)
				res_array.append(pos)
				res_array.append(pos + mirror_largest_side)
				res_array.append(pos + mirror_smallest_side)
				res_array.append(pos + mirror_smallest_side + mirror_largest_side)

	return PoolVector2Array(res_array)


# Algorithm based on http://members.chello.at/easyfilter/bresenham.html
func _get_ellipse_points (pos: Vector2, size: Vector2) -> Array:
	var array := []
	var x0 := int(pos.x)
	var x1 := pos.x + int(size.x - 1)
	var y0 := int(pos.y)
	var y1 := int(pos.y) + int(size.y - 1)
	var a := int(abs(x1 - x0))
	var b := int(abs(y1 - y0))
	var b1 := b & 1
	var dx := 4*(1-a)*b*b
	var dy := 4*(b1+1)*a*a
	var err := dx+dy+b1*a*a
	var e2 := 0

	if x0 > x1:
		x0 = x1 as int
		x1 += a

	if y0 > y1:
		y0 = y1

# warning-ignore:integer_division
	y0 += (b+1) / 2
	y1 = y0-b1
	a *= 8*a
	b1 = 8*b*b

	while x0 <= x1:
		var v1 := Vector2(x1, y0)
		var v2 := Vector2(x0, y0)
		var v3 := Vector2(x0, y1)
		var v4 := Vector2(x1, y1)
		v1 = GeometryMaker.get_adjusted_point_by_tile_mode(v1)
		v2 = GeometryMaker.get_adjusted_point_by_tile_mode(v2)
		v3 = GeometryMaker.get_adjusted_point_by_tile_mode(v3)
		v4 = GeometryMaker.get_adjusted_point_by_tile_mode(v4)
		array.append(v1)
		array.append(v2)
		array.append(v3)
		array.append(v4)

		e2 = 2*err;

		if e2 <= dy:
			y0 += 1
			y1 -= 1
			dy += a
			err += dy

		if e2 >= dx || 2*err > dy:
			x0+=1
			x1-=1
			dx += b1
			err += dx

	while y0-y1 < b:
		var v1 := Vector2(x0-1, y0)
		var v2 := Vector2(x1+1, y0)
		var v3 := Vector2(x0-1, y1)
		var v4 := Vector2(x1+1, y1)
		v1 = GeometryMaker.get_adjusted_point_by_tile_mode(v1)
		v2 = GeometryMaker.get_adjusted_point_by_tile_mode(v2)
		v3 = GeometryMaker.get_adjusted_point_by_tile_mode(v3)
		v4 = GeometryMaker.get_adjusted_point_by_tile_mode(v4)
		array.append(v1)
		array.append(v2)
		array.append(v3)
		array.append(v4)
		y0+=1
		y1-=1

	return array


func _fill_bitmap_with_points(points: Array, size: Vector2) -> BitMap:
	var bitmap := BitMap.new()
	bitmap.create(size)

	for point in points:
		bitmap.set_bit(point, 1)

	return bitmap

# tile mode에 의해서 조정된 좌표리턴
static func get_adjusted_point_by_tile_mode(point)->Vector2:
	if !StaticData.enabled_tilemode:
		return point
	if point.x < 0:
		point.x += StaticData.canvas_width
	if point.y < 0:
		point.y += StaticData.canvas_height
	if point.x >= StaticData.canvas_width:
		point.x -= StaticData.canvas_width
	if point.y >= StaticData.canvas_height:
		point.y -= StaticData.canvas_height
	return point
	
			
# 두 점 사이의 circle에 대한 pixel을 만들어서 리턴
static func get_pixels_in_circle(from:Vector2, to:Vector2, fill, thickness:int=1)->Array:
	from.x = floor(from.x) as int
	from.y = floor(from.y) as int
	to.x = floor(to.x) as int
	to.y = floor(to.y) as int
	
		
	var from_real = Vector2(min(to.x, from.x), min(to.y, from.y))
	var to_real = Vector2(max(to.x, from.x), max(to.y, from.y))
	if from_real == to_real:
		return []

	to_real.x = to_real.x + 1
	to_real.y = to_real.y + 1
	var size = Vector2(to_real.x - from_real.x, to_real.y - from_real.y)
	var points:PoolVector2Array
	if fill:
		points = GeometryMaker._get_ellipse_points_filled_on_origin(size, thickness)
	else:
		points = GeometryMaker._get_ellipse_points_on_origin(size, thickness)
		
	var pixels = []
	for p in points:
		var pos = p + from_real
		pos = GeometryMaker.get_adjusted_point_by_tile_mode(pos)
		if NodeManager.get_current_layer().has_point(pos):
			pixels.append(pos)
			
	append_symmetry_pixels(pixels)
	return pixels
	
# 두점 사이의 사각형에 대한 pixel을 만들어서 리턴
static func get_pixels_in_rectangle(from:Vector2, to:Vector2, fill=false, thickness:int=1)->Array:
	var points : Array = []


	if fill:
		var from_x:int = floor(from.x) as int
		var from_y:int = floor(from.y) as int
		var to_x:int = floor(to.x) as int
		var to_y:int = floor(to.y) as int
		
		var min_x = min(from_x, to_x)
		var max_x = max(from_x, to_x)
		var min_y = min(from_y, to_y)
		var max_y = max(from_y, to_y)
		
		for x in range(min_x, max_x+1):
			for y in range(min_y, max_y+1):
				var pos = Vector2(x, y)
				pos = get_adjusted_point_by_tile_mode(pos)
				if NodeManager.get_current_layer().has_point(pos):
					points.append(pos)
		append_symmetry_pixels(points)
	else:
		# 가로선들 
		var hor1 = get_pixels_in_line(Vector2(from.x, to.y), to, thickness)
		var hor2 = get_pixels_in_line(from, Vector2(to.x, from.y), thickness)
		var vert1 = get_pixels_in_line(from, Vector2(from.x, to.y), thickness)
		var vert2 = get_pixels_in_line(Vector2(to.x, from.y), to, thickness)
		
		for p in hor1:
			points.append(p)
		for p in hor2:
			points.append(p)
		for p in vert1:
			points.append(p)
		for p in vert2:
			points.append(p)
	return points
	
static func get_pixels_by_thickness(position:Vector2, thickness:int)->Array:
	var points : Array = []
	if StaticData.brush_type == StaticData.BrushType.rectangle || thickness <= 2:
		var start := position - Vector2.ONE * (thickness >> 1)
		var end := start + Vector2.ONE * thickness
		for y in range(floor(start.y), floor(end.y)):
			for x in range(floor(start.x), floor(end.x)):
				var pos = Vector2(x, y)
				pos = get_adjusted_point_by_tile_mode(pos)
				points.append(pos)
	else:
		
		var from:Vector2 = Vector2.ZERO
		var to:Vector2 = Vector2.ZERO
		
		from.x = floor(position.x - thickness / 2.0)
		from.y = floor(position.y - thickness / 2.0)
		to.x = from.x + (thickness - 1)
		to.y = from.y + (thickness - 1)
		points = GeometryMaker.get_pixels_in_circle(from, to, true, 1)

	return points
			
static func append_valid_points(target:Array, src:Array):
	var layer = NodeManager.get_current_layer()
	if layer == null:
		return
	for pos in src:
		if layer.has_point(pos):
			target.append(pos)
	
# symmetry된 point를 리턴한다.
static func get_symmetry_pixel(point:Vector2)->Vector2:
	if StaticData.symmetry_type == StaticData.SymmetryType.no:
		return point
		
	if StaticData.symmetry_type == StaticData.SymmetryType.horizontal:
		var diff = StaticData.horizontal_symmetry_position - point.x
		return Vector2(point.x + diff * 2 - 1, point.y)
	elif StaticData.symmetry_type == StaticData.SymmetryType.vertical:
		var diff = StaticData.vertical_symmetry_position - point.y
		return Vector2(point.x, point.y + diff * 2 - 1)
	return point
			
		
		
# symmetry 가 적용된 pixels을 추가한다.
static func append_symmetry_pixels(points):
	if StaticData.symmetry_type == StaticData.SymmetryType.no:
		return points
		
	var old_points:Array = points.duplicate()
	for p in old_points:
		var new_point = get_symmetry_pixel(p)
		if new_point == null:
			return
		if NodeManager.get_current_layer().has_point(new_point):
			points.append(new_point)
	
		
	
# 두점 사이의 선에 대한 pixel을 만들어서 리턴
static func get_pixels_in_line(from: Vector2, to: Vector2, thickness:int=1, apply_symmetry:bool=true)->Array:
	var points : Array = []
	
	if from == null || to == null:
		return points
		
	var x1:int = floor(from.x) as int
	var y1:int = floor(from.y) as int
	var x2:int = floor(to.x) as int
	var y2:int = floor(to.y) as int
	
	
	var dx = (x2 - x1)
	var dy = (y2 - y1)
	var offset:int = 1
	
	if abs(dx) > abs(dy):	
		if x2 < x1:
			offset = -1
		for x in range(x1, x2, offset):
			var y = y1 + dy * (x - x1) / dx
			var new_points = get_pixels_by_thickness(Vector2(x, y), thickness)
			append_valid_points(points, new_points)
			
	else:
		if y2 < y1:
			offset = -1
		for y in range(y1, y2, offset):
			var x = x1 + dx * (y - y1) / dy
			var new_points = get_pixels_by_thickness(Vector2(x, y), thickness)
			append_valid_points(points, new_points)
#			var pos = Vector2(x, y)
#			if NodeManager.get_current_layer().has_point(pos):
#				points.append(pos)
			
	# 마지막점 추가
	var new_points = get_pixels_by_thickness(to, thickness)
	append_valid_points(points, new_points)
#	if NodeManager.get_current_layer().has_point(to):
#		points.append(to)
	
	if apply_symmetry:
		append_symmetry_pixels(points)
		
	return points

