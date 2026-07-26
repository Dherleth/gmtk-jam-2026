extends Node3D

var balloon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	balloon = DialogueManager.show_dialogue_balloon_scene("res://dialogue/balloon.tscn", load("res://dialogue/test.dialogue"), "start")
	#balloon.global_position = $Marker3D.global_position
	#balloon.scale = Vector3(0.2, 0.2, 0.2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
