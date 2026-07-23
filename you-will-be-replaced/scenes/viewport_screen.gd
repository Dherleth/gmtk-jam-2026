extends MeshInstance3D

@onready var viewport = $SubViewport
@export var anim: String = "screen_glow"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#if $AnimationPlayer != null:
		#$AnimationPlayer.play(anim)
	get_surface_override_material(0).albedo_texture = viewport.get_texture()
