extends Button

func _ready():
	Util.set_tooltip(self, tr("Create brush"), "Ctrl+B")


func run():
	if !StaticData.enabled_selected_area():
		return
	
	# 선택영역을 이미지로 만든
	var image = Util.create_image_from_selected_area()
	
	# brush로 등록
	var origin_point = Vector2()
	origin_point.x = floor(StaticData.selected_area.position.x + StaticData.selected_area.end.x)/2
	origin_point.y = floor(StaticData.selected_area.position.y + StaticData.selected_area.end.y)/2
	var new_user_brush = NodeManager.get_user_brushes().add_user_brush(image, origin_point)
	
	# brush button 갱신
	NodeManager.get_brush_type_button().update_user_brush_buttons()
	
	# 선택영역 해제
	NodeManager.get_tools().finish_selected_area_editing()
	
	# 마지막에 추가한 브러쉬를 사용하도록 설정
	StaticData.brush_type = StaticData.BrushType.User
	StaticData.set_current_user_brush(new_user_brush)
	
# brush를 등록한다.
func _on_AddBrushButton_pressed():
	run()
	
func _process(_delta):
	disabled = !StaticData.enabled_selected_area()
