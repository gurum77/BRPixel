extends Node

enum Tool{pencil, line}

var current_tool = Tool.pencil
var current_color = Color.black
var current_layer = null
var preview_layer = null

var canvas_width = 64
var canvas_height = 64
