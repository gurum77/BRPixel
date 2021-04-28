extends Control
class_name Edit

onready var origin_selected_area:Rect2 = StaticData.selected_area
var origin_image:Image
onready var select:Select = get_tree().root.get_node_or_null("Main/Tools/Select")

var drag_position = null
var use_preview_layer = false

func _ready():
	if select == null:
		return
		
	NodeManager.get_tools().init_to_start_tool(self, StaticData.Tool.edit, !use_preview_layer)

	# 선택 영역을 image로
	origin_image = Util.create_image_from_selected_area(use_preview_layer)
	
	# select 뒤에 있는 모든 grip과 connect
	var nodes = select.get_children()
	for node in nodes:
		if node is Grip:
			node.connect("moved", self, "on_grip_moved", [node as Grip])
	
# 새롭게 변경된 select area로 이미지를 만든다.
func make_resized_image()->Image:
	var resized_image = Util.clone_image(origin_image)
	resized_image.resize(StaticData.selected_area.size.x, StaticData.selected_area.size.y, Image.INTERPOLATE_LANCZOS)
	return resized_image
	
func _input(event):
	if StaticData.invalid_mouse_pos_for_tool(StaticData.Tool.edit):
		return
		
	
	if InputManager.is_action_just_pressed_lbutton(event):
		# grip위가 아니고 선택영역의 안쪽을 클릭하면 drag가 된다.
		if !select.is_mouse_on_grip() && StaticData.selected_area.has_point(get_global_mouse_position()):
			drag_position = get_global_mouse_position()
			set_grips_drag_start_point()
	# mouse l button을 떼면.. 마무리
	elif InputManager.is_action_just_released_lbutton(event):
		# 선택영역의 바깥쪽을 클릭하면 edit는 끝이 난다.
		#  그립 위에 있다면 끝 아님
		# 반드시 lbutton released로 해야함. pressed하고 다음 액션으로 자동으로 넘어가고, released되면서 다음 액션이 동작해버림
		if !select.is_mouse_on_grip() && !StaticData.selected_area.has_point(get_global_mouse_position()):
			finish_edit()
		else:
			drag_position = null
			
	# mouse이동중 drag 효과
	if InputManager.is_action_pressed_lbutton(event) && drag_position != null:
		move_grips(get_global_mouse_position() - drag_position)
		
# grip의 start_point를 설정한다.(move 기능을 위함)
func set_grips_drag_start_point():
	var nodes = select.get_children()
	for node in nodes:
		var grip = node as Grip
		grip.start_point = grip.rect_position
		
# grip을 이동한다.		
func move_grips(move):
	move.x = move.x as int
	move.y = move.y as int
	var nodes = select.get_children()
	for node in nodes:
		var grip = node as Grip
		grip.rect_position = grip.start_point + move

	# grip 1개를 이동처리한다.
	if nodes.size() > 0:
		on_grip_moved(nodes[0] as Grip)
			

# edit
func finish_edit():
	UndoManager.prepare_undo_for_draw_on_current_layer()
	# 이미지의 크기를 조정한다.
	var resized_image = make_resized_image()

	# 처음 선택한 영역을 지운다. 
	# 단, preview layer를 사용한 경우에는 지우지 않는다.
	if !use_preview_layer:
		NodeManager.get_current_layer().erase_pixels_by_rect(origin_selected_area, false)
	
	# 이미지를 preview layer에 그린다.
	NodeManager.get_current_layer().copy_image(resized_image, NodeManager.get_current_layer().image, StaticData.selected_area.position.x, StaticData.selected_area.position.y)
	NodeManager.get_current_layer().update_texture()
	UndoManager.append_undo_for_draw_on_current_layer_by_2Rects(origin_selected_area, StaticData.selected_area)
	UndoManager.commit_undo_for_draw_on_current_layer()
	NodeManager.get_preview_layer().clear()
	
	# select 영역 편집을 마무리 한다.(선택 영역 제거를 하고 마지막 실행했던 drawing tool을 실행)
	NodeManager.get_tools().finish_selected_area_editing()
	
	
func on_grip_moved(grip):
	if grip == null:
		return
		
	# 변경된 그립의 위치로 select area를 갱신한다.
	select.on_grip_moved(grip)
	
	# 이미지의 크기를 조정한다.
	var resized_image = make_resized_image()

	# preview layer에 이미지를 그린다.
	Util.draw_image_on_preview_layer(resized_image, StaticData.selected_area.position)
