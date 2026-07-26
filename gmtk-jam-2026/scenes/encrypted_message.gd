extends Control

@onready var text: RichTextLabel = $EncryptedWindow/ColorRect3/ColorRect4/Text
@onready var text_2: RichTextLabel = $EncryptedWindow/ColorRect3/ColorRect4/Text2
@onready var text_3: RichTextLabel = $EncryptedWindow/ColorRect3/ColorRect4/Text3
@onready var text_4: RichTextLabel = $EncryptedWindow/ColorRect3/ColorRect4/Text4
@onready var text_5: RichTextLabel = $EncryptedWindow/ColorRect3/ColorRect4/Text5
@onready var input_group: Control = $EncryptedWindow/ColorRect3/ColorRect4/InputGroup
@onready var input_group_2: Control = $EncryptedWindow/ColorRect3/ColorRect4/InputGroup2
@onready var input_group_3: Control = $EncryptedWindow/ColorRect3/ColorRect4/InputGroup3
@onready var input_group_4: Control = $EncryptedWindow/ColorRect3/ColorRect4/InputGroup4
@onready var countdown_timer: Timer = $"../CountDownWindow/CountdownTimer"
@onready var animation_player: AnimationPlayer = $"../../TaskBar/CountDownButton/Control/AnimationPlayer"
@onready var more_time_label: Label = $"../../TaskBar/CountDownButton/Control/Label"

var group1_solved := false
var group2_solved := false
var group3_solved := false
var group4_solved := false


func _ready() -> void:
	text.show()
	text_2.hide()
	text_3.hide()
	text_4.hide()
	text_5.hide()
	input_group.show()
	input_group_2.hide()
	input_group_3.hide()
	input_group_4.hide()
	more_time_label.hide()
	_connect_inputs_solved(input_group)
	_connect_inputs_solved(input_group_2)
	_connect_inputs_solved(input_group_3)
	_connect_inputs_solved(input_group_4)
	
func _process(delta: float) -> void:
	if not group1_solved:
		group1_solved = _test_group(input_group)
	elif not group2_solved:
		text_2.show()
		input_group_2.show()
		group2_solved = _test_group(input_group_2)
	elif not group3_solved:
		text_3.show()
		input_group_3.show()
		group3_solved = _test_group(input_group_3)
	elif not group4_solved:
		text_4.show()
		input_group_4.show()
		group4_solved = _test_group(input_group_4)
	else:
		text_5.show()
		

func _test_group(group) -> bool:
	var solved = true
	for input: EInput in group.get_children():
		if not input.found:
			solved = false
			break
			
	return solved
	
	
func _connect_inputs_solved(group) -> void:
	for input: EInput in group.get_children():
		input.solved.connect(_on_input_solved)
		

func _on_input_solved(_text) -> void:
	var new_left_time = countdown_timer.time_left + 30.0
	animation_player.play("pop")
	countdown_timer.wait_time = new_left_time
	countdown_timer.start()
