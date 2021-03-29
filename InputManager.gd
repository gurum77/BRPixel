extends Node

func is_action_just_pressed_rbutton(event)->bool:
	if Input.is_action_just_pressed("right_button"):
		return true
	return false
	
func is_action_just_pressed_lbutton(event)->bool:
	if Input.is_action_just_pressed("left_button"):
		return true
	if event is InputEventScreenTouch && event.pressed:
		return true
	return false

func is_action_just_released_lbutton(event)->bool:
	if Input.is_action_just_released("left_button"):
		return true
	if event is InputEventScreenTouch && !event.pressed:
		return true
	return false
	
func is_action_pressed_lbutton(event)->bool:
	if Input.is_action_pressed("left_button"):
		return true
	if event is InputEventScreenDrag:
		return true
	return false
