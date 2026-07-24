extends RayCast3D

@onready var interact_prompt_label = $Label
var interactor_on: bool = true


func _process(_delta: float) -> void:
	var object = get_collider()
	interact_prompt_label.text = ""
	
	if not Menu.is_open:
		if object and object is Interactable && interactor_on:
			if object.can_interact == false:
				return
				
			interact_prompt_label.text = "[LMB] " + object.interact_prompt
			


func _unhandled_input(_event: InputEvent) -> void:
	var object = get_collider()
	
	if not Menu.is_open:
		if object and object is Interactable && interactor_on:
			if object.can_interact == false:
				return
			
			if Input.is_action_just_pressed("interact"):
				object._interact(get_parent().get_parent())
	
