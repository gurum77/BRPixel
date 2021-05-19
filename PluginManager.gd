extends Node

var godot_share = null
var godot_get_image = null

func get_godot_get_image():
	if godot_get_image == null:
		if Engine.has_singleton("GodotGetImage"):
			godot_get_image = Engine.get_singleton("GodotGetImage")
			if godot_get_image != null:
				godot_get_image.connect("error", self, "_on_error")
				godot_get_image.connect("permission_not_granted_by_user", self, "_on_permission_not_granted_by_user")
	return godot_get_image
	
func _on_error(e):
	Util.show_message(self, "Error!", e, 2)
	
# user가 권한을 주지 않은 경우
func _on_permission_not_granted_by_user(permission):
	var permission_text = permission.capitalize().split(".")[-1]
	var msg = permission_text + "\n permission is necessary"
	Util.show_message(self, msg)
	
	# Set the plugin to ask user for permission again
	if get_godot_get_image() != null:
		get_godot_get_image().resendPermission()
	
func get_godot_share():
	if godot_share == null:
		if Engine.has_singleton("GodotShare"):
			godot_share = Engine.get_singleton("GodotShare")
	if godot_share == null:
		Util.show_message(self, "godot share == null")
	return godot_share
