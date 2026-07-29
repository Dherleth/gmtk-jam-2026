@tool
extends Control
class_name ColumnLine

@export var text: String:
	set(value):
		text = value
		_text_updated()
@export var display_icon := false:
	set(value):
		display_icon = value
		_display_icon_updated()

var icon_node: Control
var text_node: Label


func _display_icon_updated() -> void:
	if not icon_node:
		icon_node = find_child("Icon")
		
	if icon_node:
		icon_node.visible = display_icon


func _text_updated() -> void:
	if not text_node:
		text_node = find_child("TextLabel")
		
	if text_node:
		text_node.text = text
