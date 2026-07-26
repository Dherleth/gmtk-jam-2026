extends Camera3D

@export var look_sensitivity: float = 0.005
var camera_look_input: Vector2
var is_free: bool = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	#camera look
	#if is_free:
		#rotate_y(-camera_look_input.x * look_sensitivity)
		#rotation.x = clamp(rotation.x, -0.5, 0.5)
		#rotate_x(-camera_look_input.y * look_sensitivity)
		#rotation.y = clamp(rotation.y, -1.2, 0.7)
		#camera_look_input = Vector2.ZERO
		#
		#rotation.z = 0
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && is_free:
		camera_look_input = event.relative
		
func lock_camera(lock: bool):
	is_free = !lock
