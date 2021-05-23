extends Control

onready var horizontal_grip1 = $HorizontalGrip1
onready var horizontal_grip2 = $HorizontalGrip2
onready var vertical_grip1 = $VerticalGrip1
onready var vertical_grip2 = $VerticalGrip2


func _process(_delta):
	horizontal_grip1.visible = StaticData.symmetry_type == StaticData.SymmetryType.horizontal
	horizontal_grip2.visible = horizontal_grip1.visible
	
	vertical_grip1.visible = StaticData.symmetry_type == StaticData.SymmetryType.vertical
	vertical_grip2.visible = vertical_grip1.visible
	
func _ready():
	# symmetryGrips는 크기가 있으면 안됨(다른 control에 메세지가 안감)
	rect_size = Vector2(0, 0)
	
	horizontal_grip1.connect("moved", self, "on_grip_moved", [horizontal_grip1])
	horizontal_grip2.connect("moved", self, "on_grip_moved", [horizontal_grip2])
	vertical_grip1.connect("moved", self, "on_grip_moved", [vertical_grip1])
	vertical_grip2.connect("moved", self, "on_grip_moved", [vertical_grip2])
	horizontal_grip1.preview = false
	horizontal_grip2.preview = false
	vertical_grip1.preview = false
	vertical_grip2.preview = false
	
func on_grip_moved(grip):
	if StaticData.symmetry_type == StaticData.SymmetryType.horizontal:
		StaticData.horizontal_symmetry_position = grip.rect_position.x
	elif StaticData.symmetry_type == StaticData.SymmetryType.vertical:
		StaticData.vertical_symmetry_position = grip.rect_position.y
	update_canvas_and_grips()
	
func update_canvas_and_grips():
	NodeManager.get_canvas().update()
	# grip 위치 조정
	var gap = 0
	if StaticData.symmetry_type == StaticData.SymmetryType.horizontal:
		var min_y = -gap
		var max_y = StaticData.canvas_height + gap
		if StaticData.enabled_tilemode:
			min_y -= StaticData.canvas_height
			max_y += StaticData.canvas_height
		horizontal_grip1.rect_position = Vector2(StaticData.horizontal_symmetry_position, min_y)
		horizontal_grip2.rect_position = Vector2(StaticData.horizontal_symmetry_position, max_y)		
	elif StaticData.symmetry_type == StaticData.SymmetryType.vertical:
		var min_x = -gap
		var max_x = StaticData.canvas_width + gap
		if StaticData.enabled_tilemode:
			min_x -= StaticData.canvas_width
			max_x += StaticData.canvas_width
		vertical_grip1.rect_position = Vector2(min_x, StaticData.vertical_symmetry_position)
		vertical_grip2.rect_position = Vector2(max_x, StaticData.vertical_symmetry_position)
		
			
