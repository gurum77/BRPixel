extends TextureRect
class_name Canvas
# play 변수에 직접 할당하지 않아야 하므로 _ 붙임
export var _play = false

func _ready():
	# 0,0으로 고정한다.
	rect_position = Vector2(0, 0)
	
	# 시작하면 지정된 크기로 resize를 한다
	resize()
	
# 그리드를 그린다.
func _draw():
	if StaticData.enabled_tilemode:
		draw_tile_check_patterns()
	if StaticData.enabled_grid:
		draw_grid()
	if StaticData.symmetry_type != StaticData.SymmetryType.no:
		draw_symmetry_guide_line()
	
# symmetry guid line 그리기	
func draw_symmetry_guide_line():
	if StaticData.symmetry_type == StaticData.SymmetryType.horizontal:
		var min_y = 0
		var max_y = StaticData.canvas_height
		if StaticData.enabled_tilemode:
			min_y -= StaticData.canvas_height
			max_y += StaticData.canvas_height
		draw_line(Vector2(StaticData.horizontal_symmetry_position, min_y), Vector2(StaticData.horizontal_symmetry_position, max_y), Color.blue)
	elif StaticData.symmetry_type == StaticData.SymmetryType.vertical:
		var min_x = 0
		var max_x = StaticData.canvas_width
		if StaticData.enabled_tilemode:
			min_x -= StaticData.canvas_width
			max_x += StaticData.canvas_width
		draw_line(Vector2(min_x, StaticData.vertical_symmetry_position), Vector2(max_x, StaticData.vertical_symmetry_position), Color.blue)
		
func draw_tile_check_patterns():
	var rect = Rect2(-StaticData.canvas_width, -StaticData.canvas_height, StaticData.canvas_width * 3, StaticData.canvas_height * 3)
	draw_texture_rect(texture, rect, true)
	
func draw_grid_by_position_offset(position_offset):
	var color = Color.darkgray
	var color_double_line = Color.red
	var offset = 16
	var double_line_offset = 2
	
	
	var idx = 0
	for x in range(0, StaticData.canvas_width, offset):
		if idx > 0 && idx % double_line_offset == 0:
			draw_line(position_offset + Vector2(x, 0), position_offset + Vector2(x, StaticData.canvas_height), color_double_line)
		else:
			draw_line(position_offset + Vector2(x, 0), position_offset + Vector2(x, StaticData.canvas_height), color)
		idx += 1
			
	idx = 0
	for y in range(0, StaticData.canvas_height, offset):
		if idx > 0 && idx % double_line_offset == 0:
			draw_line(position_offset + Vector2(0, y), position_offset + Vector2(StaticData.canvas_width, y), color_double_line)
		else:
			draw_line(position_offset + Vector2(0, y), position_offset + Vector2(StaticData.canvas_width, y), color)
		idx += 1		
		
func draw_grid():
	draw_grid_by_position_offset(Vector2(0, 0))
	if StaticData.enabled_tilemode:
		var position_offsets = NodeManager.get_tile_mode_manager().get_tiles_position_offsets()
		for po in position_offsets:
			draw_grid_by_position_offset(po)
		# tile mode라면 가운데(원래 grid) 테두리를 파랗게 그려준다.
		var pline = []
		pline.append(Vector2(0, 0))
		pline.append(Vector2(StaticData.canvas_width, 0))
		pline.append(Vector2(StaticData.canvas_width, StaticData.canvas_height))
		pline.append(Vector2(0, StaticData.canvas_height))
		pline.append(Vector2(0, 0))
		draw_polyline(pline, Color.blue)
	

# canvas를 크기를 조정한다.
# 크기에 맞게 흰색으로 만든다.
func resize():
	var image = Image.new()
	
	var width = StaticData.canvas_width
	var height = StaticData.canvas_height
		
	image.create(width, height, false, Image.FORMAT_RGBA8)
	image.lock()
	
	# white
	for y in range(0, image.get_height(), 2):
		for x in range(0, image.get_width(), 2):
			image.set_pixel(x, y, Color.white)
	for y in range(1, image.get_height(), 2):
		for x in range(1, image.get_width(), 2):
			image.set_pixel(x, y, Color.white)
	
	# gray
	for y in range(0, image.get_height(), 2):
		for x in range(1, image.get_width(), 2):
			image.set_pixel(x, y, Color.lightgray)
	for y in range(1, image.get_height(), 2):
		for x in range(0, image.get_width(), 2):
			image.set_pixel(x, y, Color.lightgray)
	
	image.unlock()
	
	texture = ImageTexture.new()
	texture.create_from_image(image)
	texture.flags = 0
	
	
func is_playing():
	return _play
	
func play():
	if _play:
		stop()	
		
	_play = true
	$AnimationTimer.start(StaticData.delay_per_frame)
	
func stop():
	_play = false
	$AnimationTimer.stop()

func _on_AnimationTimer_timeout():
	if !_play:
		return
	var frame_count = NodeManager.get_frames().get_frame_count()
	if frame_count <= 1:
		return
		
	StaticData.current_frame_index += 1
	if StaticData.current_frame_index >= frame_count:
		StaticData.current_frame_index = 0
	
