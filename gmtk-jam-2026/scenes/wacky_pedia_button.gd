@tool
extends Control

signal wacky_link_pressed(searchTerm: String)
@onready var button: Button = $Button

@export var text :String
@export var search_term: String


func _ready() -> void:
	button.text = text
	
	
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		button.text = text

func _on_button_pressed() -> void:
	wacky_link_pressed.emit(search_term)
