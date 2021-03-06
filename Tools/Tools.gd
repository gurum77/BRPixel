extends Control
class_name Tools

var pencil_tool = preload("res://Tools/Pencil.tscn")
var select_tool = preload("res://Tools/Select.tscn")
var edit_tool = preload("res://Tools/Edit.tscn")
var circle_tool = preload("res://Tools/Circle.tscn")
var rectangle_tool = preload("res://Tools/Rectangle.tscn")
var line_tool = preload("res://Tools/Line.tscn")
var fill_tool = preload("res://Tools/Fill.tscn")
var change_color = preload("res://Tools/ChangeColor.tscn")
var darker_tool = preload("res://Tools/Darker.tscn")
var brighter_tool = preload("res://Tools/Brighter.tscn")
var eraser_tool = preload("res://Tools/Eraser.tscn")

func is_drawing_tool(tool_node:Node)->bool:
	if tool_node is LineTool:
		return true
	if tool_node is CircleTool:
		return true
	if tool_node is RectangleTool:
		return true
	if tool_node is FillTool:
		return true
	if tool_node is ChangeColorTool:
		return true
	return false
	
# 현재 진행중인 drawing tool을 종료시킨다.
func finish_current_drawing_tool():
	var nodes = get_children()
	for node in nodes:
		if !is_drawing_tool(node):
			continue
			
		node.queue_free()
	
		
# selected area 편집을 마무리 한다.
# 선택 영역을 해제하고, 마지막으로 실행했던 drawing tool을 실행한다.
func finish_selected_area_editing():
	# select 영역을 제거하고 edit 기능도 종료한다.
	StaticData.clear_selected_area()
	var select:Select = get_tree().root.get_node_or_null("Main/Tools/Select")
	if select != null:
		select.call_deferred("queue_free")
	
	# 마지막 실행했던 drawing tool을 실행한다.
	NodeManager.get_tools().run_last_drawing_tool()

# edit 관련 tool을 시작하기 위한 초기화를 한다.
# 현재 툴은 제거하지 않는다.
func init_to_start_tool(current_tool, tool_type, clear_preview_layer=true):
	# 미리 보기 제거를 하고, 크기도 현재 canvas에 맞춘다.
	# preview layer는 상황에 따라 크기가 변하기 때문...
	if clear_preview_layer:
		StaticData.preview_layer.init_size()
		StaticData.preview_layer.clear(true)
	
	# 현재 툴 설정
	StaticData.current_tool = tool_type
	
	# 다른 툴을 모두 제거
	# select tool을 제거하는지?
	var clear_select_tool = true
	# edit는 제거하지 않는다.
	# drawing tool(pen, line등)은 원래 제거하지 않았었지만, 선택영역만 그리기 상황이 혼돈을 유발해서 
	# 제거하기로 함
	# 추후, 여기에 대한 필요성이 발생하면 drawing tool 시작시 select tool을 제거할지 다시 고민하자.
	if tool_type == StaticData.Tool.edit:
		clear_select_tool = false
	NodeManager.clear_other_tools(current_tool, !clear_select_tool)
		
	
	
# 마지막으로 실행한 그리기 툴을 실행한다.	
# todo : 일단 pencil로 고정
func run_last_drawing_tool():
	if StaticData.last_drawing_tool != null:
		var last_tool = StaticData.last_drawing_tool.instance()
		if last_tool is RectangleTool || last_tool is CircleTool:
			last_tool.fill = StaticData.fill_for_last_drawing_tool
		NodeManager.get_tools().add_child(last_tool)
	else:
		NodeManager.get_tools().add_child(pencil_tool.instance())
	
func find_select_tool()->Select:
	var nodes = get_children()
	for node in nodes:
		if node is Select:
			return node as Select
	return null
	
func find_edit_tool()->Node:
	var nodes = get_children()
	for node in nodes:
		if node is Edit:
			return node as Node
	return null
	
# select 기능을 실행한다.
# 이미 실행 되어 있다면 실행하지 않는다.
# use_preview_layer : true - select가 실행될때 preview layer를 초기화 하지 않도록 한다.
func run_select_tool(use_preview_layer)->Select:
	var select = find_select_tool()
	if select != null:
		return select
	select = select_tool.instance()
	select.use_preview_layer = use_preview_layer
	NodeManager.get_tools().add_child(select)
	return select
	
	
func run_edit_tool(use_preview_layer):
	var edit = find_edit_tool()
	
	# edit는 삭제하고 다시 실행한다.
	# 초기화 문제..
	if edit != null:
		edit.call_deferred("queue_free")
		
	edit = edit_tool.instance()
	edit.use_preview_layer = use_preview_layer
	NodeManager.get_tools().add_child(edit)
	return edit
