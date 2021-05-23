extends Panel
var v_bar_lenght = 0
var bar_swipe = 0
func _ready():
	v_bar_lenght = $ScrollContainer.get_v_scrollbar().get_instance_id()
	
func _gui_input(event):
	pass
#		if event is InputEventScreenDrag:
#			if (event.relative.y > 1):
#				bar_swipe -= 20
#				bar_swipe = clamp(bar_swipe, 0, 140)
#				if bar_swipe >= v_bar_lenght:
#					bar_swipe = v_bar_lenght
#				$ScrollContainer.set_v_scroll(bar_swipe)
#
#			if (event.relative.y < 0):
#				bar_swipe += 20
#				bar_swipe = clamp(bar_swipe, 0, 140)
#				$ScrollContainer.set_v_scroll(bar_swipe)
