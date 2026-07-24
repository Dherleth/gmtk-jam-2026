extends Control

@export var dialogue_resource: DialogueResource

@onready var scroll: ScrollContainer = %Scroll
@onready var v_scroll_bar: VScrollBar = %VScrollBar
@onready var content: VBoxContainer = %Content
@onready var dialogue_box: DialogueBox = %DialogueBox
@onready var answer_overlay: ColorRect = %AnswerOverlay
@onready var answer_edit: LineEdit = %AnswerEdit
@onready var submit_button: Button = %SubmitButton
@onready var responses_overlay: ColorRect = %ResponsesOverlay
@onready var responses_menu: DialogueResponsesMenu = %ResponsesMenu

signal message_sent

var favourite_food: String = ""
var childhood_dog: String = "":
	set(dog_name):
		childhood_dog = dog_name
		Menu.dog_name = dog_name
var correct_answer: int = 0
var correct_question: String = ""
var question: String = ""
var tries: int = 0
var guess_is_number: bool = false
var click_block: bool = false


#region Hooks


func _ready() -> void:
	
	submit_button.pressed.connect(_on_message_sent)
	answer_edit.text_submitted.connect(_on_message_sent_w_text)
	dialogue_box.dialogue_line = await dialogue_resource.get_next_dialogue_line("start", [self])
	dialogue_box.grab_focus()

	disable_answer()
	responses_overlay.hide()

	scroll.get_v_scroll_bar().share(v_scroll_bar)


#endregion

#region Mutations


func ask_for_string() -> String:
	click_block = true
	answer_edit.text = ""
	enable_answer()
	answer_edit.grab_focus()
	await message_sent
	click_block = false
	disable_answer()
	return answer_edit.text
	
func _on_message_sent():
	message_sent.emit()
	
func _on_message_sent_w_text(some_text):
	message_sent.emit()


func ask_for_number() -> int:
	answer_edit.text = ""
	enable_answer()
	answer_edit.grab_focus()
	await submit_button.pressed
	disable_answer()
	#guess_is_number = str(answer_edit.text.to_int()) == answer_edit.text
	tries += 1
	return answer_edit.text.to_int()


#endregion

#region Helpers


func next_line(next_id: String) -> void:
	var next_dialogue_line: DialogueLine = await dialogue_resource.get_next_dialogue_line(next_id, [self])

	if not is_instance_valid(next_dialogue_line): return

	if next_dialogue_line.type == DMConstants.TYPE_RESPONSE:
		responses_overlay.show()
		responses_menu.responses = next_dialogue_line.responses
		responses_menu.get_menu_items()[0].grab_focus()
	else:
		var copy: DialogueBox = dialogue_box.duplicate()
		content.add_child(copy)
		content.move_child(copy, dialogue_box.get_index())
		dialogue_box.dialogue_line = next_dialogue_line

		await get_tree().create_timer(0.2).timeout
		scroll.set_deferred("scroll_vertical", 10000)

		dialogue_box.grab_focus()


func handle_click(event: InputEvent) -> void:
	var is_left_click: bool = event.is_pressed() and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT
	var is_accept_key: bool = event.is_action_pressed("ui_accept")
	var key_press: bool = event is InputEventKey and event.pressed
	if is_left_click or is_accept_key or key_press:
		get_viewport().set_input_as_handled()
		if dialogue_box.is_typing:
			dialogue_box.skip_typing()
		else:
			next_line(dialogue_box.dialogue_line.next_id)


#endregion

#region Signals


func _on_gui_input(event: InputEvent) -> void:
	if !click_block:
		handle_click(event)


func _on_dialogue_box_gui_input(event: InputEvent) -> void:
	if !click_block:
		handle_click(event)


func _on_responses_menu_response_selected(response: Variant) -> void:
	responses_overlay.hide()
	next_line(response.next_id)


func _on_answer_edit_gui_input(event: InputEvent) -> void:
	if event.is_pressed() and event is InputEventKey and (event as InputEventKey).keycode == KEY_ENTER:
		submit_button.pressed.emit()


#endregion


func _on_window_closed() -> void:
	hide()

func disable_answer():
	answer_edit.editable = false
	submit_button.disabled = true
	
func enable_answer():
	answer_edit.editable = true
	submit_button.disabled = false

func _on_window_visibility_changed() -> void:
	if $Window.visible:
		show()
