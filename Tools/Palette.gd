extends Control
class_name Palette

var colors:Array
export var default_colors = true
func _ready():
	if default_colors:
		make_default_colors()
	
func clear_colors():
	colors.clear()
	
func get_color_255(r, g, b):
	return Color(r/255.0, g/255.0, b/255.0, 1)
	
func get_save_dic()->Dictionary:
	var _save_dic:Dictionary
	_save_dic["colors"] = get_save_dic_colors()
	return _save_dic

func get_save_dic_colors()->Dictionary:
	var _save_dic:Dictionary
	for i in colors.size():
		var col = colors[i] as Color
		_save_dic[i] = col.to_html()
	return _save_dic
	
func set_save_dic(dic:Dictionary):
	# 기존 color를 제거한다.
	colors.clear()
	if !dic.has("colors"):
		return
	var dic_colors:Dictionary = dic["colors"]
	
	for key in dic_colors.keys():
		var color = Color(dic_colors[key])
		colors.append(color)
		
func set_color(index, color):
	var add_count = (index + 1) - colors.size()
	for i in add_count:
		colors.append(color)
	colors[index] = color
	
func make_default_colors():
	colors.clear()
	colors.append(get_color_255(245, 245, 245))
	colors.append(get_color_255(0, 0, 0))
	colors.append(get_color_255(161, 161, 161))
	colors.append(get_color_255(81, 81, 81))
	colors.append(get_color_255(123, 0, 0))
	colors.append(get_color_255(245, 0, 0))
	colors.append(get_color_255(123, 73, 0))
	colors.append(get_color_255(245, 147, 0))
	colors.append(get_color_255(98, 123, 0))
	colors.append(get_color_255(196, 245, 0))
	colors.append(get_color_255(24, 123, 0))
	colors.append(get_color_255(49, 245, 0))
	colors.append(get_color_255(0, 123, 49))
	colors.append(get_color_255(0, 245, 98))
	colors.append(get_color_255(0, 123, 123))
	colors.append(get_color_255(0, 245, 245))
	colors.append(get_color_255(0, 49, 123))
	colors.append(get_color_255(0, 98, 245))
	colors.append(get_color_255(24, 0, 123))
	colors.append(get_color_255(49, 0, 245))
	colors.append(get_color_255(98, 0, 123))
	colors.append(get_color_255(196, 0, 245))
	colors.append(get_color_255(123, 0, 74))
	colors.append(get_color_255(245, 0, 245))


func set_palette_from_image(image:Image):
	var w = image.get_width()
	var h = image.get_height()
	var dic:Dictionary = Dictionary()
	
	image.lock()
	for x in range(0, w):
		for y in range(0, h):
			dic[image.get_pixel(x, y)] = true
	image.unlock()
	
	colors.clear()
	for c in dic:
		colors.append(c)

# 팔레트의 칼라를 정렬한다.
func sort():
	colors.sort()
	
