extends ColorRect

var selected_x = 0
var selected_y = 0

func reposition_selected_xy():
	var selected_color:Color = get_parent().get_selected_color()
	selected_x = rect_size.x * selected_color.s
	selected_y = rect_size.y * (1 - selected_color.v)
	$LastColorSelectorLine.update()
	
func get_color_on_mouse()->Color:
	var color = get_base_color()
	# x 방향 보간
	var factor = selected_x / rect_size.x
	color = Color.white.linear_interpolate(color, factor)
	# y 방향 보간
	factor = selected_y / rect_size.y
	color = color.linear_interpolate(Color.black, factor)
	return color
	
func _draw():
	var width = rect_size.x
	var height = rect_size.y
	# 좌측상단은 255, 255, 255
	# 우측상단은 baseColor
	# 좌측하단은 0, 0, 0
	# 우측하단은 0, 0, 0
	var base_color = get_base_color()
	var points = [Vector2(0, 0), Vector2(width, 0), Vector2(width, height), Vector2(0, height), Vector2(0, 0)]
	var colors = [Color.white, base_color, Color.black, Color.black, Color.white]
	draw_polygon(points, colors)
	
func get_base_color()->Color:
	return get_parent().get_node("FirstColorSelector").get_color_on_mouse()
	
func _ready():
	update()

