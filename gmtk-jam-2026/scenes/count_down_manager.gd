extends Control


@onready var countdown_timer: Timer = $"../CountdownTimer"
@onready var minute: Label = $"../ColorRect3/ColorRect4/Minute"
@onready var seconds: Label = $"../ColorRect3/ColorRect4/Seconds"
@onready var button_label: Label = $"../../../TaskBar/CountDownButton/Digits/Label"



func _process(delta: float) -> void:
	if not countdown_timer.is_stopped():
		minute.text =  str(int(countdown_timer.time_left / 60))
		seconds.text = str(int(countdown_timer.time_left) % 60).pad_zeros(2)
		
		if countdown_timer.time_left > 180:
			button_label.text =  "countdown"
		elif countdown_timer.time_left > 120:
			button_label.text =  "countdown"
		elif countdown_timer.time_left > 60:
			button_label.text =  "countdown"
		elif countdown_timer.time_left > 0:
			button_label.text =  "< 60s"
