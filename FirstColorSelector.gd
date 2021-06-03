extends ColorRect

var colors = []
var selected_x = 0
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

	
	for x in width:
		var color = get_color_by_x(x)
		var from = Vector2(x, 0)
		var to = Vector2(x, height)
		draw_line(from, to, color, 2, false)
	

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


