extends Node3D

@export var new_texture: Resource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func change_texture():
	get_child(0).get_surface_override_material(0).albedo_texture = new_texture
