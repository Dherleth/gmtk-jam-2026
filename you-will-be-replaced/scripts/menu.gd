extends CanvasLayer

var master_vol = AudioServer.get_bus_index("Master")

var screen_is_open: bool = false
var dog_name: String = "Charlie"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$ColorRect/Window2/SettingCont/VolumeSlider.value = db_to_linear(master_vol)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if !visible:
			show()
		else:
			hide()

func show_end_text():
	$ColorRect/EndText.show()

func _on_play_button_pressed() -> void:
	hide()
	$ColorRect/Window2.hide()
	$ColorRect/Window3.hide()


func _on_settings_pressed() -> void:
	$ColorRect/Window2.spawn()


func _on_credits_pressed() -> void:
	$ColorRect/Window3.spawn()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_visibility_changed() -> void:
	pass
	#if visible:
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#else:
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_sensi_slider_drag_ended(value_changed: bool) -> void:
	pass
	#Context.look_sensitivity = $ColorRect/SettingCont/SensiSlider.value

func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_vol, linear_to_db(value))


func _on_label_3_toggled(toggled_on: bool) -> void:
	pass


func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_start_pressed() -> void:
	hide()
	$ColorRect/Window2.hide()
	$ColorRect/Window3.hide()
