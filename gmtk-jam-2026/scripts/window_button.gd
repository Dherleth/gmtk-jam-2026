extends TextureButton


@export var window: Control
@export var parent: Control

func _ready() -> void:
	pressed.connect(_on_button_pressed)
	
	
func _on_button_pressed():
	if !window.visible && parent != null:
		parent.spawn(window)
	
