extends Button
class_name TaskBarButton


@export var window: OsWindow


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		window.display()
	else:
		window.minimize()
