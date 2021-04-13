extends Button



export (StaticData.SymmetryType) var symmetry_type
var grip1 = null
var grip2 = null

func _ready():
	if symmetry_type == StaticData.SymmetryType.horizontal:
		grip1 = NodeManager.get_symmetry_grips().get_node_or_null("./HorizontalGrip1")
		grip2 = NodeManager.get_symmetry_grips().get_node_or_null("./HorizontalGrip2")
	elif symmetry_type == StaticData.SymmetryType.vertical:
		grip1 = NodeManager.get_symmetry_grips().get_node_or_null("./VerticalGrip1")
		grip2 = NodeManager.get_symmetry_grips().get_node_or_null("./VerticalGrip2")
	if grip1 != null && grip2 != null:
		grip1.connect("moved", self, "on_grip_moved", [grip1])
		grip2.connect("moved", self, "on_grip_moved", [grip2])
		grip1.preview = false
		grip2.preview = false
		
func on_grip_moved(grip):
	if symmetry_type == StaticData.SymmetryType.horizontal:
		StaticData.horizontal_symmetry_position = grip.rect_position.x
	elif symmetry_type == StaticData.SymmetryType.vertical:
		StaticData.vertical_symmetry_position = grip.rect_position.y
	update_canvas_and_grips()
		
func _on_SymmetryButton_pressed():
	StaticData.symmetry_type = symmetry_type
	update_canvas_and_grips()
func update_canvas_and_grips():
	NodeManager.get_canvas().update()
	# grip 위치 조정
	var gap = 20
	if symmetry_type == StaticData.SymmetryType.horizontal:
		var min_y = -gap
		var max_y = StaticData.canvas_height + gap
		if StaticData.enabled_tilemode:
			min_y -= StaticData.canvas_height
			max_y += StaticData.canvas_height
		grip1.rect_position = Vector2(StaticData.horizontal_symmetry_position, min_y)
		grip2.rect_position = Vector2(StaticData.horizontal_symmetry_position, max_y)		
	elif symmetry_type == StaticData.SymmetryType.vertical:
		var min_x = -gap
		var max_x = StaticData.canvas_width + gap
		if StaticData.enabled_tilemode:
			min_x -= StaticData.canvas_width
			max_x += StaticData.canvas_width
		grip1.rect_position = Vector2(min_x, StaticData.vertical_symmetry_position)
		grip2.rect_position = Vector2(max_x, StaticData.vertical_symmetry_position)
		
		

func _process(_delta):
	var need_to_pressed = StaticData.symmetry_type == symmetry_type
	if pressed != need_to_pressed:
		pressed = need_to_pressed
	var need_to_visible_grips = false
	if symmetry_type != StaticData.SymmetryType.no:
		need_to_visible_grips = StaticData.symmetry_type == symmetry_type
	if grip1 != null && grip1.visible != need_to_visible_grips:
		grip1.visible = need_to_visible_grips
	if grip2 != null && grip2.visible != need_to_visible_grips:
		grip2.visible = need_to_visible_grips
		
	
	
