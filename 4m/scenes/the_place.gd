extends Node3D

var screen_scene = preload("res://scenes/screen.tscn")
@onready var screen_container: SubViewportContainer = $Desk/Pc/Quad/SubViewport/ScreenContainer
@onready var start_working_timer: Timer = $StartWorkingTimer
@onready var show_encrypted_window_timer: Timer = $ShowEncryptedWindowTimer
@onready var show_countdown_timer: Timer = $ShowCountdownTimer
@onready var start_countdown_timer: Timer = $StartCountdownTimer

var screen_instance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_instance = screen_scene.instantiate()
	screen_container.add_child(screen_instance)
	
	show_encrypted_window_timer.timeout.connect(_on_show_encrypted_window_timer_timeout)
	show_countdown_timer.timeout.connect(_on_show_countdown_timer_timeout)
	start_working_timer.timeout.connect(_on_start_working_timer_timeout)
	start_countdown_timer.timeout.connect(_on_start_countdown_timer_timeout)
	
	screen_instance.explosion.connect(_on_explosion)
	
	show_countdown_timer.start()


func _on_start_working_timer_timeout() -> void:
	%CamAP.play("zoom_screen")
	show_encrypted_window_timer.start()
	
func _on_show_encrypted_window_timer_timeout() ->void:
	screen_instance.hide_countdown_window()
	screen_instance.show_encrypted_window()
	
func _on_show_countdown_timer_timeout() ->void:
	screen_instance.show_countdown_window()
	start_countdown_timer.start()
	
func _on_start_countdown_timer_timeout() ->void:
	screen_instance.start_count_down()
	start_working_timer.start()
	
func _on_explosion():
	$CanvasLayer.show()
	$CanvasLayer/AnimationPlayer.play("show_text")
