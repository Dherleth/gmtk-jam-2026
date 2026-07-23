extends InteractableObject


func _ready() -> void:
	Menu.visibility_changed.connect(_menu_visibility_changed)

# Called when the node enters the scene tree for the first time.
func _interact(_body):
	%CamAP.play("zoom_screen")
	can_interact = false

func _menu_visibility_changed():
	can_interact = !Menu.visible
