extends Control

@onready var timer = %Timer
@onready var countdown = %Countdown

var is_open: bool = false
var first_id_press: bool = true

var memory = ["You remember the time you had to hand feed Charlie when he was sick as a puppy."]

var dog_list = ["dog", "puppy"]
var animal_list = ["cat", "rabbit", "cow", "mouse"]
var adjectives = [
	["adorable ", "sleeping ", "cute ", "anxious ", "scared ", "happy ",],
	[ "bleeding ", "rotting ", "tortured ", "dead "]
	]
var limbs = [
	[" with %s heads", 1], 
	[" with %s paws", 4], 
	[" with %s ears", 2], 
	[" with %s eyes", 2], 
	[" with %s tails", 1]
	]
var place = [" on a farm", " in a field", " in a cage", " on a couch"]
var lists = [
	dog_list,
	animal_list
]
var selected_animal = "dog"
var limbs_num: int = 0
var picked_limb = ["", 1]

var min_quota: int = 15

var annotated_images: int = 0:
	set(val):
		annotated_images = val
		%Quota.text = "Minimum quota: " + str(val) + "/" + str(min_quota)
		if annotated_images >= min_quota:
			%Quota.text = "Daily quota reached!"
		if val == 1:
			spawn($SalaryWindow)
		if val == 8:
			selected_animal = "dog"
			%Description.text = memory[0]

var salary: float = 0.00:
	set(val):
		salary = val
		%Salary.text = "Salary: $ " + str(val).pad_decimals(2)
		
var strikes: int = 0:
	set(val):
		strikes = val
		if val == 1:
			spawn($Window2)
		$Window2/Label.text += "X"
		if val == 3:
			game_over()
			
var red_flag: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	countdown.value = countdown.max_value
	timer.wait_time = countdown.max_value

func _process(delta: float) -> void:
	if !timer.is_stopped():
		countdown.value = timer.time_left

func _on_yes_pressed() -> void:
	check_answer(true)


func _on_no_pressed() -> void:
	check_answer(false)


func change_image():
	var num = randi_range(1, 10)
	var path = "res://DOGS/DOG"+ str(num) +"_blur.jpg"
	%Image.texture = load(path)
	
func create_word():
	var all_this = ""
	var selected_list = lists.pick_random()
	selected_animal = selected_list.pick_random()
	var chance = randi_range(0,10)
	if chance < 7:
		var selected_adjective = adjectives.pick_random()
		all_this += selected_adjective.pick_random()
	all_this += selected_animal
	if chance < 6:
		limbs_num = chance
		picked_limb = limbs.pick_random()
		all_this += picked_limb[0] % str(chance)
	else:
		limbs_num = 0
	if chance > 2:
		all_this += place.pick_random()
	%Description.text = all_this
	
func check_answer(yes: bool):
	if yes:
		if dog_list.has(selected_animal) && limbs_num <= picked_limb[1]:
			salary += 0.01
		else:
			strikes += 1
	if !yes:
		if dog_list.has(selected_animal) && limbs_num <= picked_limb[1]:
			strikes += 1
		else:
			salary += 0.01
			
	change_image()
	reset_flags()
	
	if annotated_images != 5:
		create_word()
	
func spawn(window):
	window.modulate.a = 0.0 # invisible
	window.show()
	window.pivot_offset.y = size.y # pivot at bottom (for scaling)
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	
	tween.tween_property(window, "modulate:a", 1.0, 0.2)
	tween.parallel().tween_property(window, "scale:y", 1.0, 0.2).from(-1)
	
func game_over():
	timer.stop()
	spawn($GameOverWindow)
	for window in get_tree().get_nodes_in_group("window"):
		window.despawn()
	for button in get_tree().get_nodes_in_group("apps"):
		button.disabled = true
		
func reset_flags():
	%RedFlag.button_pressed = false
	red_flag = false


func _on_ok_button_pressed() -> void:
	$WelcomeWindow.hide()
	#spawn($TimeWindow)
	timer.start()
	$ColorRect2/Time.disabled = false


func _on_start_pressed() -> void:
	hide()
	is_open = false


func _on_dont_delete_doc_pressed() -> void:
	if !$DontWindow.visible:
		spawn($DontWindow)


func _on_more_instruct_ok_button_pressed() -> void:
	$MoreInstructWindow.despawn()


func _on_eidme_button_pressed() -> void:
	if first_id_press && !$InfoWindow.visible:
		spawn($InfoWindow)
		first_id_press = false
		


func _on_timer_timeout() -> void:
	spawn($EndWindow)
	for window in get_tree().get_nodes_in_group("window"):
		window.despawn()
	for button in get_tree().get_nodes_in_group("apps"):
		button.disabled = true


func _on_info_button_pressed() -> void:
	first_id_press = false


func _on_gameover_button_pressed() -> void:
	print("you lost")


func _on_red_flag_toggled(toggled_on: bool) -> void:
	red_flag = toggled_on
