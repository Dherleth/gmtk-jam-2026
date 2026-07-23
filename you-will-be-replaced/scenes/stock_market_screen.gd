extends MeshInstance3D

@onready var viewport = $SubViewport

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_surface_override_material(0).albedo_texture = viewport.get_texture()
