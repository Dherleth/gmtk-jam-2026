class_name DialogueBox extends MarginContainer


signal finished_typing


const CHARACTERS = {
	chatter = {
		portrait = preload("res://portraits/nathan.svg"),
		side = "left",
		color = Color(1, 0.869, 0.776)
	},
	me = {
		portrait = preload("res://portraits/coco.svg"),
		side = "right",
		color = Color(0.755, 0.908, 1)
	}
}


var dialogue_line: DialogueLine:
	set(value):
		dialogue_line = value
		update_dialogue()
	get:
		return dialogue_line

var is_typing:
	get:
		return dialogue_label.is_typing

@onready var dialogue: HBoxContainer = %Dialogue
@onready var background: ColorRect = %Background
@onready var character_name: Label = %CharacterName
@onready var dialogue_label: DialogueLabel = %DialogueLabel
@onready var left_character: TextureRect = %LeftCharacter
@onready var right_character: TextureRect = %RightCharacter
@onready var action_label: Label = %ActionLabel


## Finish typing instantly
func skip_typing() -> void:
	dialogue_label.skip_typing()


func update_dialogue() -> void:
	left_character.texture = null
	right_character.texture = null

	if dialogue_line.character.is_empty():
		dialogue.hide()
		action_label.show()
		action_label.text = dialogue_line.text
	else:
		dialogue.show()
		action_label.hide()
		character_name.text = dialogue_line.character

	dialogue_label.dialogue_line = dialogue_line

	if not dialogue_line.character.is_empty():
		dialogue_label.type_out()


#region Signals


func _on_dialogue_label_finished_typing() -> void:
	if is_inside_tree():
		finished_typing.emit()


#endregion
