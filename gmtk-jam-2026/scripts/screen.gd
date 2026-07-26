extends Control

signal dezoom
@onready var encrypted_button: TextureButton = $TaskBar/EncryptedButton
@onready var count_down_button: TextureButton = $TaskBar/CountDownButton
@onready var countdown_timer: Timer = $Windows/CountDownWindow/CountdownTimer
@onready var notif: AudioStreamPlayer = $Windows/CountDownWindow/Notif
@onready var office_music: AudioStreamPlayer = $Office
@onready var explosion_sound: AudioStreamPlayer = $ExplosionSound
@onready var credit_window: Control = $Windows/CreditWindow


func spawn(window):
	window.modulate.a = 0.0 # invisible
	window.show()
	window.pivot_offset.y = size.y # pivot at bottom (for scaling)
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	
	tween.tween_property(window, "modulate:a", 1.0, 0.2)
	tween.parallel().tween_property(window, "scale:y", 1.0, 0.2).from(-1)
	
	
func despawn_and_disable():
	for window in get_tree().get_nodes_in_group("window"):
		window.despawn()
	for button in get_tree().get_nodes_in_group("apps"):
		button.disabled = true
		
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
	count_down_button.pressed.emit()
	count_down_button.set_pressed_no_signal(false)
	encrypted_button.pressed.emit()
	encrypted_button.set_pressed_no_signal(false)
	countdown_timer.wait_time = 10
	countdown_timer.start()
	

func _on_countdown_timer_timeout() -> void:
	office_music.stop()
	explosion_sound.play()
	credit_window.spawn()
