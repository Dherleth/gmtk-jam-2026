extends Control


@onready var countdown_timer: Timer = $"../CountdownTimer"
@onready var minute: Label = $"../ColorRect3/ColorRect4/Minute"
@onready var seconds: Label = $"../ColorRect3/ColorRect4/Seconds"


func _process(delta: float) -> void:
	if not countdown_timer.is_stopped():
		minute.text =  str(int(countdown_timer.time_left / 60))
		seconds.text = str(int(countdown_timer.time_left) % 60).pad_zeros(2)
