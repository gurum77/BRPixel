extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	$DraggableWindow.hide()
	resize()
	
func resize():
	var total_width = 0
	var nodes = $DraggableWindow/HBoxContainer.get_children()
	for node in nodes:
		if node is Button:
			var but:Button = node
			total_width = total_width + but.rect_size.x

	var margins = $DraggableWindow/HBoxContainer.margin_left + $DraggableWindow/HBoxContainer.margin_right
	var sparations = $DraggableWindow/HBoxContainer.get_constant("separation") * nodes.size()
	var close_button_width = 0
	$DraggableWindow.rect_size.x = total_width + margins + sparations + close_button_width
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# 클릭을 하면 child를 우측으로 표시한다.
func _on_SubmenuPopupButton_pressed():
	if $DraggableWindow.visible:
		$DraggableWindow.hide()
	else:
		$DraggableWindow.show()
	
