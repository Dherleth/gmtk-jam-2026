extends Control

signal dezoom
@onready var encrypted_button: TextureButton = $TaskBar/EncryptedButton
@onready var count_down_button: TextureButton = $TaskBar/CountDownButton


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
	encrypted_button.set_pressed_no_signal(true)
