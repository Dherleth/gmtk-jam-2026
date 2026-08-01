@tool
extends LineEdit
class_name EInput

signal solved(text: String)

@export var to_find: Array[String]

var color_found = Color("00ff00ff")
var color_standard = Color("61c6ff")
var found = false


func _ready() -> void:
	add_theme_color_override("font_color", color_standard)
	add_theme_color_override("font_uneditable_color", color_found)
	
	
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if to_find.size() > 0:
			placeholder_text = to_find[0]
			

func _enter_tree() -> void:
	placeholder_text = ""


func _on_text_changed(new_text: String) -> void:
	if to_find.has(new_text.to_lower()):
		editable = false
		add_theme_color_override("font_color", color_found)
		found = true
		solved.emit(new_text)
	else:
		add_theme_color_override("font_color", color_standard)
