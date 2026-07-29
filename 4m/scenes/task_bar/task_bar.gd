extends ColorRect


@onready var buttons_container: HBoxContainer = $HBoxContainer/ButtonsContainer
var task_bar_button_scene = preload("res://scenes/task_bar/task_bar_button.tscn")


func _ready() -> void:
	OperatingSystem.window_opened.connect(_on_os_window_opened)
	OperatingSystem.window_closed.connect(_on_os_window_closed)
	
	
func _on_os_window_opened(window: OsWindow) -> void:
	var button_already_exists = false
	for button: TaskBarButton in buttons_container.get_children():
		if button.window == window:
			button_already_exists = true
			break
	
	if not button_already_exists:
		var button_instance: TaskBarButton = task_bar_button_scene.instantiate()
		button_instance.window = window
		button_instance.text = window.title
		buttons_container.add_child(button_instance)
	
	
func _on_os_window_closed(window: OsWindow) -> void:
	for button: TaskBarButton in buttons_container.get_children():
		if button.window == window:
			button.queue_free()
			break
