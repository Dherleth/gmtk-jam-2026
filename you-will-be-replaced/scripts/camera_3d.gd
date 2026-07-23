extends Camera3D

@export_group("Camera")
@export var look_sensitivity: float = 0.005
var camera_look_input: Vector2
var is_free: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#camera look
	if is_free:
		rotate_y(-camera_look_input.x * look_sensitivity)
		rotation.x = clamp(rotation.x, -0.5, 0.5)
		rotate_x(-camera_look_input.y * look_sensitivity)
		rotation.y = clamp(rotation.y, -1.2, 0.7)
		camera_look_input = Vector2.ZERO
		
		rotation.z = 0
	
	# Mouse
	#if Input.is_action_just_pressed("ui_cancel"):
		#if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		#else:
			#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && is_free:
		camera_look_input = event.relative
		
func lock_camera(lock: bool):
	is_free = !lock
