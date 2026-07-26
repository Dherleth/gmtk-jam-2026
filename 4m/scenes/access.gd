extends Control


@onready var access: Control = $"../Access"
@onready var list: Control = $"../List"
@onready var hint: Label = $"../Access/Hint"
@onready var password_input: LineEdit = $"../Access/Password"
@onready var username_input: LineEdit = $"../Access/Username"

var password = "toby"


func _ready() -> void:
	hint.hide()
	access.show()
	list.hide()


func _on_password_text_submitted(new_text: String) -> void:
	password_input.grab_focus()
	if new_text != password:
		hint.show()
	else:
		access.hide()
		list.show()


func _on_username_text_changed(new_text: String) -> void:
	username_input.text = "M.Saltman"
