extends CanvasLayer

var is_open := false

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
