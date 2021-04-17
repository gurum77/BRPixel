extends Control
class_name TileModeManager


var enabled_draw = false
func init_tile_layers():
	# layer의 크기를 현재 canvas의 크기에 맞게 조정하고 위치도 조정한다.
	var w = StaticData.canvas_width
	var h = StaticData.canvas_height
	var nodes = get_children()
	for node in nodes:
		if node is Layer:
			node.init_size()
	
	$TileLayer_LT.rect_position = Vector2(-w, h)
	$TileLayer_T.rect_position = Vector2(0, h)
	$TileLayer_RT.rect_position = Vector2(w, h)
	$TileLayer_L.rect_position = Vector2(-w, 0)
	$TileLayer_R.rect_position = Vector2(w, 0)
	$TileLayer_LB.rect_position = Vector2(-w, -h)
	$TileLayer_B.rect_position = Vector2(0, -h)
	$TileLayer_RB.rect_position = Vector2(w, -h)
	
func _input(_event):
	enabled_draw =true
func update_force():
	enabled_draw = true
	update()
func _draw():
	if !enabled_draw:
		return
		
	var current_layer = NodeManager.get_current_layer()
	# 모든 layer를 하나의 image로 만든다.
	if current_layer == null:
		return
		
	var image:Image = current_layer.create_image(StaticData.canvas_width, StaticData.canvas_height)
	image.fill(Color.transparent)
	
	var layers = NodeManager.get_current_layers().get_normal_layers()
	for layer in layers:
		if !layer.visible:
			continue
		layer.copy_image(layer.image, image, 0, 0)
		
	# preview layer도 복사한다.
	StaticData.preview_layer.copy_image(StaticData.preview_layer.image, image, 0, 0)
		
	# texture로 만든다.
	var nodes = get_children()
	for node in nodes:
		if node is Layer:
			var layer = node as Layer
			layer.image = image
			layer.update_texture()
		

func _on_Timer_timeout():
	update()

# 각 타일들의 위치 offset 정보를 리턴한다.
func get_tiles_position_offsets()->Array:
	var offsets = []
	var w = StaticData.canvas_width
	var h = StaticData.canvas_height
	offsets.append(Vector2(-w, h))
	offsets.append(Vector2(0, h))
	offsets.append(Vector2(w, h))
	offsets.append(Vector2(-w, 0))
	offsets.append(Vector2(w, 0))
	offsets.append(Vector2(-w, -h))
	offsets.append(Vector2(0, -h))
	offsets.append(Vector2(w, -h))
	return offsets
	
