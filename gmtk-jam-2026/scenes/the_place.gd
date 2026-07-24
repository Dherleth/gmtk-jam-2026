extends Node3D

var screen_scene = preload("res://scenes/screen.tscn")
@onready var screen_container: SubViewportContainer = $Desk/Pc/Quad/SubViewport/ScreenContainer
@onready var monitor: Interactable = $Desk/Pc/Monitor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var screen_instance = screen_scene.instantiate()
	screen_instance.dezoom.connect(_on_dezoom)
	screen_container.add_child(screen_instance)

func _on_dezoom():
	%CamAP.play_backwards("zoom_screen")
	monitor.can_interact = true
