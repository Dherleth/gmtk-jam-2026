extends Button


@export var window: Control

func _ready() -> void:
	pressed.connect(_on_button_pressed)
	
func _process(_delta: float) -> void:
	text = str(Time.get_time_dict_from_system()["hour"]) + ":" + str(Time.get_time_dict_from_system()["minute"]).pad_zeros(2)
	
	
func _on_button_pressed():
	if !window.visible:
		pass
		#Screen.spawn(window)
	
