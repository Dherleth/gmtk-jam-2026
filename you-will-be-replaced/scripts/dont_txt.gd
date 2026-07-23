extends TextEdit

var input_ready: bool = false
var full_text = "What do you mean? Who wrote this?"
var writing_text = ""
var i = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_caret_changed() -> void:
	if !input_ready:
		select_all()
		input_ready = true
	

func _on_focus_entered() -> void:
	pass


func _input(event):
	if %DontWindow.visible:
		if input_ready and event is InputEventKey and event.pressed:
			if i < full_text.length():
				writing_text += full_text[i]
				text = ""
				text += writing_text
				i += 1
			else:
				text = full_text
