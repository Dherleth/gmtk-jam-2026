extends Control

@onready var timer = %Timer
@onready var countdown = %Countdown

signal cake_time
signal bottle_time
signal dezoom
signal restart

var first_id_press: bool = true
var red_flag: bool = false

var loaded_dog_textures = [
	preload("res://DOGS/DOG1_blur.jpg"),
	preload("res://DOGS/DOG2_blur.jpg"),
	preload("res://DOGS/DOG3_blur.JPG"),
	preload("res://DOGS/DOG4_blur.JPG"),
	preload("res://DOGS/DOG5_blur.JPG"),
	preload("res://DOGS/DOG6_blur.JPG"),
	preload("res://DOGS/DOG7_blur.JPG"),
	preload("res://DOGS/DOG8_blur.jpg"),
	preload("res://DOGS/DOG9_blur.jpg"),
	preload("res://DOGS/DOG10_blur.jpg"),
]

var memory_num = [7, 16, 25, 37, 44]
var i = 0
var memory = [
	"The place behind the dog looks oddly familiar.",
	"There's a dog standing in front of the school you went to as a child.",
	"You recognise the street behind the dog. It's where your parents live.",
	"The dog looks oddly familiar. It reminds you of your childhood family dog.",
	"You remember the time you had to hand feed %s when he was sick as a puppy."
	]

var dog_list = ["dog", "puppy"]
var animal_list = ["cat", "cat", "cat", "rabbit", "rabbit", "cow", "mouse"]
var adjectives = [
	["adorable ", "sleeping ", "cute ", "anxious ", "scared ", "happy ", "angry ", "brown "],
	[]
	]
var limbs = [
	[" with %s head", 1], 
	[" with %s paw", 4], 
	[" with %s ear", 2], 
	[" with %s eye", 2], 
	[" with %s tail", 1],
	[" with %s head", 1], 
	[" with %s paw", 4], 
	[" with %s ear", 2], 
	[" with %s eye", 2], 
	[" with %s tail", 1],
	[" with %s tail", 1],
	]
var place = [" on a farm", " in a field", " in a cage", " on a couch", " on the streets"]
var lists = [
	dog_list,
	animal_list
]
var selected_animal = "dog"
var selected_adjective = "adorable "
var limbs_num: int = 0
var picked_limb = ["", 1]
var limb_string = ""

var info_total = ""
var info_list = [
	"- 1 head\n",
	"- 4 paws\n",
	"- 2 ears\n",
	"- 2 eyes\n",
	"- 1 tail\n"
]
var violence_list = [
	"- blood\n",
	"- torture\n",
	"- death\n",
]

var annotated_images: int = 0:
	set(val):
		annotated_images = val
		
		%Triangle.value = annotated_images
		
		%Quota.text = "Annotated images: " + str(val)
		if val == 1:
			$SalaryWindow.spawn()
			$ColorRect2/Money.disabled = false
			
		if memory_num.has(annotated_images):
			selected_animal = "dog"
			selected_adjective = "adorable "
			limbs_num = 1
			picked_limb = ["", 1]
			if i == 4:
				%Description.text = memory[i] % Menu.dog_name
			else:
				%Description.text = memory[i]
			i += 1
			
		if val % 5 == 0:
			level += 1
			money += 0.01
			
		if val == 5:
			$MoreInstructWindow.spawn()
			$InfoWindow.despawn()
			$InfoWindow2.spawn()
			$info_button.window = $InfoWindow2

var money: float = 0.01
var salary: float = 0.00:
	set(val):
		salary = val
		%Salary.text = "Salary: $ " + str(val).pad_decimals(2)
		
var min_quota: int = 10
var level: int = 0:
	set(val):
		level = val
		$NotificationWindow.spawn()
		$NotificationWindow/notif.play()
		%Level.text = "Current level: " + str(level) + "/10"
		if level == 5:
			$WelcomeWindow2.spawn()
			$pos_notif.play()
		if level == 7:
			$WelcomeWindow3.spawn()
			$pos_notif.play()
		if level < 6 && level > 0:
			info_total += info_list[level-1]
			limb_string = "The rules are as follow:\n- A dog is a dog.\n- A puppy is a dog.\n- Any other animal is NOT a dog.\n\nA dog with more than\n %s is NOT a dog."
			%AddedInfo.text = limb_string % info_total
			$InfoWindow2.size.y += 22
		if level == 6:
			$%RedFlag.show()
			%AddedInfo.text += "\n\nYou need to flag every image with violent content (no matter the animal).\n\nWhat we consider as violent:\n-Amputation (missing body parts)\n"
		if level == 7:
			adjectives[1].append("bleeding ")
		if level == 8:
			adjectives[1].append("tortured ")
		if level == 9:
			adjectives[1].append("dead ")
		if level < 10 and level > 6:
			%AddedInfo.text += violence_list[level-7]
		if level == 10:
			$WelcomeWindow4.spawn()
			$pos_notif.play()
			despawn_and_disable()
			
		
var strikes: int = 0:
	set(val):
		strikes = val
		$Window2.spawn()
		$Window2/Label.text += "X"
		$Window2/error.play()
		if val == 5:
			game_over()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	countdown.value = countdown.max_value
	timer.wait_time = countdown.max_value
	$ColorRect2/Money.disabled = true
	Menu.visibility_changed.connect(_welcome_window)

func _process(_delta: float) -> void:
	if !timer.is_stopped():
		countdown.value = timer.time_left

func _welcome_window():
	$WelcomeWindow.spawn()
	$pos_notif.play()

func _on_yes_pressed() -> void:
	check_answer(true)


func _on_no_pressed() -> void:
	check_answer(false)


func change_image():
	%Image.texture = loaded_dog_textures.pick_random()
	
func create_word():
	var all_this = ""
	
	var selected_list = lists.pick_random()
	selected_animal = selected_list.pick_random()
	
	var chance = randi_range(0,100)
	
	if level < 7:
		if chance < 85:
			selected_adjective = adjectives[0].pick_random()
			all_this += selected_adjective
	else:
		if annotated_images == 35 or annotated_images == 40 or annotated_images == 45:
			selected_adjective = adjectives[1][level-7]
			print(selected_adjective)
			all_this += selected_adjective
		elif chance < 98:
			var adj_group = adjectives.pick_random()
			selected_adjective = adj_group.pick_random()
			all_this += selected_adjective
		else:
			selected_adjective = " adorable"
			
	
	if annotated_images == 5:
		all_this += "dog"
		var one_to_five = randi_range(2,5)
		limbs_num = one_to_five
		picked_limb = limbs[0]
		all_this += picked_limb[0] % str(one_to_five) + "s"
	elif annotated_images == 30:
		all_this += selected_animal
		limbs_num = 0
		picked_limb = limbs[0]
		all_this += picked_limb[0] % str(0)
	elif level > 0 && chance < 88:
		all_this += selected_animal
		var one_to_five = randi_range(0,5)
		limbs_num = one_to_five
		picked_limb = limbs[randi_range(0, level-1)]
		if one_to_five > 1:
			all_this += picked_limb[0] % str(one_to_five) + "s"
		else:
			all_this += picked_limb[0] % str(one_to_five)
	else:
		all_this += selected_animal
		limbs_num = 1
		picked_limb = ["", 1]
		
	if chance > 50:
		all_this += place.pick_random()
		
	%Description.text = all_this
	
func check_if_dog():
	return dog_list.has(selected_animal)
	
func check_limbs():
	return limbs_num <= picked_limb[1]
	
func check_amputated():
	var less_limbs = limbs_num < picked_limb[1]
	return red_flag == less_limbs
	
func check_flag():
	return red_flag == adjectives[1].has(selected_adjective)
	
func check_answer(yes: bool):
	if level < 6:
		if yes:
			if check_if_dog() and check_limbs():
				salary += money
			else:
				strikes += 1
		if !yes:
			if !check_flag():
				strikes += 1
			elif check_if_dog() and check_limbs():
				strikes += 1
			else:
				salary += money
	elif level == 6:
		if yes:
			if check_if_dog() and check_limbs() and check_amputated():
				salary += money
			else:
				strikes += 1
		if !yes:
			if !check_amputated():
				strikes += 1
			elif check_if_dog() and check_limbs():
				strikes += 1
			else:
				salary += money
	else:
		var flag_check: bool = check_flag() or check_amputated()
		if yes:
			if red_flag == false:
				if !check_flag() or !check_amputated():
					strikes += 1
			elif check_if_dog() and check_limbs() and flag_check:
				salary += money
			else:
				strikes += 1
		if !yes:
			if red_flag == false:
				if !check_flag() or !check_amputated():
					strikes += 1
			elif check_if_dog() and check_limbs():
				strikes += 1
			else:
				salary += money
				
	annotated_images += 1
	change_image()
	reset_flags()
	
	if !memory_num.has(annotated_images) or !annotated_images % 5:
		create_word()
		
func reset_flags():
	%RedFlag.button_pressed = false
	red_flag = false
	
func spawn(window):
	window.modulate.a = 0.0 # invisible
	window.show()
	window.pivot_offset.y = size.y # pivot at bottom (for scaling)
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	
	tween.tween_property(window, "modulate:a", 1.0, 0.2)
	tween.parallel().tween_property(window, "scale:y", 1.0, 0.2).from(-1)
	
func despawn_and_disable():
	for window in get_tree().get_nodes_in_group("window"):
		window.despawn()
	for button in get_tree().get_nodes_in_group("apps"):
		button.disabled = true
	
func game_over():
	timer.stop()
	$GameOverWindow.spawn()
	despawn_and_disable()


func _on_ok_button_pressed() -> void:
	$WelcomeWindow.hide()


func _on_start_pressed() -> void:
	dezoom.emit()


func _on_dont_delete_doc_pressed() -> void:
	if !$DontWindow.visible:
		$DontWindow.spawn()


func _on_more_instruct_ok_button_pressed() -> void:
	$MoreInstructWindow.despawn()
	#spawn($TimeWindow)
	#timer.start()
	$ColorRect2/Time.disabled = false


func _on_eidme_button_pressed() -> void:
	if first_id_press && !$InfoWindow.visible:
		$InfoWindow.spawn()
		first_id_press = false
		


func _on_timer_timeout() -> void:
	$EndWindow.spawn()
	despawn_and_disable()


func _on_info_button_pressed() -> void:
	first_id_press = false


func _on_gameover_button_pressed() -> void:
	restart.emit()


func _on_red_flag_toggled(toggled_on: bool) -> void:
	red_flag = toggled_on


func _on_welcome2_button_pressed() -> void:
	$WelcomeWindow2.hide()
	cake_time.emit()


func _on_button3_pressed() -> void:
	$WelcomeWindow3.hide()
	bottle_time.emit()


func _on_button_end_pressed() -> void:
	restart.emit()
