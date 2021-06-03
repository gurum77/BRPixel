extends ColorRect

var colors = []
var selected_x = 0

# selected color에 맞게 line의 위치를 다시 잡는다.
func reposition_selected_x():
	var selected_color:Color = get_parent().get_selected_color()
	selected_x = rect_size.x * selected_color.h
	$FirstColorSelectorLine.update()
	
func _draw():
	var width = rect_size.x
	var height = rect_size.y
	# 색변화단계
	# 255,  0,  0
	# 255,255,  0
	#   0,255,  0
	#   0,255,255
	#   0,  0,255
	# 255,  0,255
	# 255,  0,  0

	var points = []
	var offset = width / (colors.size()-1)
	for x in colors.size():
		points.append(Vector2(x * offset, height/2))
		
	draw_polyline_colors(points, colors, height)


func get_color_on_mouse()->Color:
	return get_color_by_x(selected_x)
	
func get_color_count():
	return (colors.size()-1) * 255
	
func get_color_by_x(x)->Color:
	if rect_size.x == 0:
		return Color.red
	if x == 0:
		return colors[0]
		
	# 몇번째 color를 가져 와야 하는지?
	var factor = x / rect_size.x
	var idx = (get_color_count() * factor) as int
	return get_color_by_index(idx)
	
	
func get_color_by_index(idx)->Color:
	var array_idx = idx / 255
	var cur_color = colors[array_idx]
	if array_idx >= colors.size()-1:
		return cur_color
	var next_color = colors[array_idx+1]
	var offset = idx - (array_idx * 255)
	return get_color_by_offset(cur_color, next_color, offset)


func get_color_by_offset(cur_color:Color, next_color:Color, offset)->Color:
	return cur_color.linear_interpolate(next_color, offset/255.0)


func _ready():
	colors.append(Color8(255, 0, 0))
	colors.append(Color8(255, 255, 0))
	colors.append(Color8(0, 255, 0))
	colors.append(Color8(0, 255, 255))
	colors.append(Color8(0, 0, 255))
	colors.append(Color8(255, 0, 255))
	colors.append(Color8(255, 0, 0))

	update()


