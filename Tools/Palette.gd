extends Control

class_name Palette

var colors:Array

func _ready():
	make_default_palette()
	StaticData.current_palette = self
	
func get_color_255(r, g, b):
	return Color(r/255.0, g/255.0, b/255.0, 1)
	
func make_default_palette():
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
	var dic:Dictionary
	
	image.lock()
	for x in range(0, w):
		for y in range(0, h):
			dic[image.get_pixel(x, y)] = true
	image.unlock()
	
	colors.clear()
	for c in dic:
		colors.append(c)
