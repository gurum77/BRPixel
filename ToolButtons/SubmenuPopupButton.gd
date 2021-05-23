extends Button
class_name SubmenuPopupButton
export (StaticData.Tool) var current_tool = StaticData.Tool.none
export (NodePath) var popup_node_path = null

var popup
var popup_hbox_container

# Called when the node enters the scene tree for the first time.
func _ready():
	if popup_node_path != null:
		popup = get_node(popup_node_path)
		popup_hbox_container = popup.get_node("HBoxContainer")
		popup.submenu_popup_button_parent = self
		
	popup.hide_close_button = true
	popup.hide()
	resize()
	
func resize():
	var total_width = 0
	var nodes = popup_hbox_container.get_children()
	for node in nodes:
		# clipboard중 사용되지 않는것은 크기조절에서 제외
		if node is ClipBoardButton:
			var but:ClipBoardButton = node
			if but.unused:
				continue
				
		# button의 크기를 더해준다.
		if node is Control:
			var but:Control = node
			total_width = total_width + but.rect_size.x

	var margins = popup_hbox_container.margin_left + popup_hbox_container.margin_right
	var sparations = popup_hbox_container.get_constant("separation") * nodes.size()
	var close_button_width = 0
	popup.rect_size.x = total_width + margins + sparations + close_button_width

func run_current_tool():
	if current_tool == StaticData.Tool.none:
		return
		
	if current_tool == StaticData.Tool.line:
		NodeManager.get_tools().add_child(NodeManager.get_tools().line_tool.instance())
		StaticData.last_drawing_tool = NodeManager.get_tools().line_tool
	elif current_tool == StaticData.Tool.rectangle:
		NodeManager.get_tools().add_child(NodeManager.get_tools().rectangle_tool.instance())
		StaticData.last_drawing_tool = NodeManager.get_tools().rectangle_tool
	elif current_tool == StaticData.Tool.circle:
		NodeManager.get_tools().add_child(NodeManager.get_tools().circle_tool.instance())
		StaticData.last_drawing_tool = NodeManager.get_tools().circle_tool
	elif current_tool == StaticData.Tool.select:
		NodeManager.get_tools().add_child(NodeManager.get_tools().select_tool.instance())
		

		
# 클릭을 하면 child를 우측으로 표시한다.
func _on_SubmenuPopupButton_pressed():
	# current_tool을 바로 실행한다.
	run_current_tool()
	
	if popup.visible:
		popup.hide()
	else:
		popup.show()

func _process(_delta):
	Util.press_current_tool_button(self, current_tool)		
		

func _on_LineSettingButton_pressed():
	pass # Replace with function body.


