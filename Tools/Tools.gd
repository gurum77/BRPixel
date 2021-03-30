extends Control
class_name Tools

# edit 관련 tool을 시작하기 위한 초기화를 한다.
# 현재 툴은 제거하지 않는다.
func init_to_start_tool(current_tool, tool_type):
	# 미리 보기 제거
	StaticData.preview_layer.clear(true)
	
	# 현재 툴 설정
	StaticData.current_tool = tool_type
	
	# 다른 툴을 모두 제거
	if tool_type == StaticData.Tool.select:
		NodeManager.clear_other_tools(current_tool, false)
	else:
		NodeManager.clear_other_tools(current_tool, true)
		
	
	
