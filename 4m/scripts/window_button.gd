extends TextureButton


@export var window: Control
@export var is_in_task_bar := false


func _ready() -> void:
	pressed.connect(_on_button_pressed)
	
		
func _on_button_pressed():
	if !window.visible:
		window.spawn()
	elif is_in_task_bar && window.visible:
		window.despawn()
