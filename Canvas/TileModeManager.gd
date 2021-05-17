extends Control
class_name TileModeManager

var draw_forced = false

func is_enabled_draw()->bool:
	if StaticData.enabled_tilemode:
		return true
	return false
		
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
	
func update_force():
	draw_forced = true
	update()
	draw_forced = false
	
func _draw():
	if !draw_forced && !is_enabled_draw():
		return
		
	var layers = NodeManager.get_current_layers()
	if layers == null:
		return
		
	var image = layers.create_layers_image()
		
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
	
