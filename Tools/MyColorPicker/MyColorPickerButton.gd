extends Button

export (Color) var selected_color = Color.white

onready var color_texture = $ColorTexture

func _draw():
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready():
	$BackgroundPanel.visible = false
	update()


		

func _on_MyColorPickerButton_pressed():
	var width = get_viewport_rect().size.x#ProjectSettings.get("display/window/size/width")
	var height = get_viewport_rect().size.y#ProjectSettings.get("display/window/size/height")
	$BackgroundPanel.visible = true
	$BackgroundPanel.rect_global_position.x = 0
	$BackgroundPanel.rect_global_position.y = 0
	$BackgroundPanel.rect_size.x = width
	$BackgroundPanel.rect_size.y = height
	
	$MyColorPicker.visible = true


func _on_BackgroundPanel_pressed():
	$BackgroundPanel.visible = false
	$MyColorPicker.visible = false
