extends TextureRect
class_name TextureRectButton

signal pressed

var disabled:bool = false
var pressed:bool = false
var button_down:bool = false
var pressed_position

export (String) var text = ""
export (bool) var toggle_mode = false
export (Texture) var background
export (Color) var background_color = Color8(57, 57, 62)#Color.lightgray

var icon = null
var pressed_sign = null

func _ready():
	var idx = 0
	var backgroundTextureRect = TextureRect.new()
	backgroundTextureRect.texture = background
	backgroundTextureRect.expand = true
	backgroundTextureRect.modulate = background_color
	set_full_rect(backgroundTextureRect)
	add_child(backgroundTextureRect)
	move_child(backgroundTextureRect, idx)
	idx+=1
	
	icon = TextureRect.new()
	icon.texture = texture
	icon.expand = expand
	icon.stretch_mode = stretch_mode
	set_full_rect(icon)
	add_child(icon)
	move_child(icon, idx)
	idx+=1

	
	pressed_sign = ColorRect.new()
	pressed_sign.color = Color.black
	pressed_sign.color.a = 0.5
	pressed_sign.mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_full_rect(pressed_sign)
	add_child(pressed_sign)
	move_child(pressed_sign, idx)
	
func set_full_rect(control):
	control.anchor_left = 0
	control.anchor_top = 0
	control.anchor_bottom = 1
	control.anchor_right = 1
	control.margin_left = 0
	control.margin_top = 0
	control.margin_right = 0
	control.margin_bottom = 0
	
func _process(_delta):
	if pressed_sign != null:
		pressed_sign.visible = pressed || button_down

func run_gui_input(event):
	_on_TextureRectButton_gui_input(event)
	
func _on_TextureRectButton_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_DOWN || event.button_index == BUTTON_WHEEL_UP:
			return
		if disabled:
			return
			
		if event.pressed:
			pressed_position = get_global_mouse_position()
			button_down = true
		else:
			button_down = false
			# drag 상황이 아닐때만 색을 선택한
			var dist = pressed_position.distance_squared_to(get_global_mouse_position())
			if dist < 100:
				_pressed()
			pressed_position = null

func _pressed():
	if toggle_mode:
		pressed = !pressed
	emit_signal("pressed")
		

func set_text(_text):
	if $Label != null:
		$Label.text = _text;
