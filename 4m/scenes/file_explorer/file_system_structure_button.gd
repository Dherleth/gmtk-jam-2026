@tool
extends Control
class_name FileSystemStructureButton

@export var text: String:
	set(value):
		text = value
		_text_updated()
@export var display_icon := false:
	set(value):
		display_icon = value
		_display_icon_updated()
@export var deepness := 0:
	set(value):
		print("in comp", value)
		deepness = value
		position.x = deepness * deepness_offset_px
@export var deepness_offset_px := 20:
	set(value):
		deepness_offset_px = value
		position.x = deepness * deepness_offset_px
		
@onready var color_rect: ColorRect = $ColorRect

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


func _on_button_mouse_entered() -> void:
	color_rect.color =Color("afafafff")


func _on_button_mouse_exited() -> void:
	color_rect.color = Color("ffffff00")
