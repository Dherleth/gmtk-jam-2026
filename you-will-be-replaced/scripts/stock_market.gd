extends Control

var money: int = 15548693
var money2: int = 677324
var money3: int = 5283543
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	money += 1
	%money.text = "$" + str(money)
	money2 += 1
	%money2.text = "$" + str(money2)
	money3 += 1
	%money3.text = "$" + str(money3)
