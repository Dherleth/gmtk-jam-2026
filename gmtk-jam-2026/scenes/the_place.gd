extends Node3D

var screen_scene = preload("res://scenes/screen.tscn")
@onready var screen_container: SubViewportContainer = $Desk/Pc/Quad/SubViewport/ScreenContainer
@onready var start_working_timer: Timer = $StartWorkingTimer
@onready var show_encrypted_window_timer: Timer = $ShowEncryptedWindowTimer
var screen_instance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_instance = screen_scene.instantiate()
	screen_container.add_child(screen_instance)
	
	show_encrypted_window_timer.timeout.connect(_on_show_encrypted_window_timer)
	show_encrypted_window_timer.start()
	
	start_working_timer.timeout.connect(_on_start_working_timer)


func _on_start_working_timer() -> void:
	%CamAP.play("zoom_screen")
	
func _on_show_encrypted_window_timer() ->void:
	screen_instance.show_encrypted_window()
	start_working_timer.start()
