extends Control

signal dezoom
@onready var encrypted_button: TextureButton = $TaskBar/EncryptedButton
@onready var count_down_button: TextureButton = $TaskBar/CountDownButton
@onready var countdown_timer: Timer = $Windows/CountDownWindow/CountdownTimer
@onready var notif: AudioStreamPlayer = $Windows/CountDownWindow/Notif
@onready var office_music: AudioStreamPlayer = $Office
@onready var explosion_sound: AudioStreamPlayer = $ExplosionSound
@onready var credit_window: Control = $Windows/CreditWindow
@onready var tick_sound: AudioStreamPlayer = $Tick
@onready var count_down_window: Control = $Windows/CountDownWindow

var played_ticking_sound = false
var reverted = true

func _process(delta: float) -> void:
	if countdown_timer.time_left <= 11 and countdown_timer.time_left > 0 and not played_ticking_sound:
		office_music.stop()
		tick_sound.play()
		reverted = false
		played_ticking_sound = true
	elif countdown_timer.time_left >= 11 and not reverted:
		office_music.play()
		tick_sound.stop()
		reverted = true
		played_ticking_sound = false
		
func show_countdown_window() ->void:
	count_down_button.pressed.emit()
	count_down_button.set_pressed_no_signal(true)
	
func hide_countdown_window() ->void:
	count_down_button.pressed.emit()
	count_down_button.set_pressed_no_signal(false)
	
func show_encrypted_window() -> void:
	encrypted_button.pressed.emit()
	notif.play()
	encrypted_button.set_pressed_no_signal(true)
	
func start_count_down() -> void:
	countdown_timer.start()


func _on_blow_it_up_button_pressed() -> void:
	office_music.stop()
	tick_sound.play()
	count_down_window.spawn()
	encrypted_button.pressed.emit()
	encrypted_button.set_pressed_no_signal(false)
	countdown_timer.wait_time = 10
	countdown_timer.start()
	

func _on_countdown_timer_timeout() -> void:
	office_music.stop()
	explosion_sound.play()
	credit_window.spawn()
