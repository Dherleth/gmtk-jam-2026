extends Control



func _ready() -> void:
	hide()

func _on_encrypted_window_opened() -> void:
	show()


func _on_encrypted_window_closed() -> void:
	hide()
