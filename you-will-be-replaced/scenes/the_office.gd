extends Node3D

var first_time: bool = true
var screen_scene = preload("res://scenes/screen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Menu.visibility_changed.connect(_on_menu_vis_changed)
	
	var screen_instance = screen_scene.instantiate()
	screen_instance.dezoom.connect(_on_dezoom)
	screen_instance.cake_time.connect(_on_cake_time)
	screen_instance.bottle_time.connect(_on_bottle_time)
	screen_instance.restart.connect(_on_restart)
	$table_large_3_42/pc_monitor_mp_13/Quad/SubViewport/ScreenContainer.add_child(screen_instance)

func _on_dezoom():
	%CamAP.play_backwards("zoom_screen")
	$table_large_3_42/pc_monitor_mp_13/Monitor.can_interact = true
	$Structre/poster_cx_44.change_texture()
	
func _on_restart():
	get_tree().reload_current_scene()
	Menu.visible = true

func _on_menu_vis_changed():
	if first_time:
		$table_large_3_42/cell_phone_32/Sprite3D/AnimationPlayer.play("show text")
		first_time = false
		
func _on_cake_time():
	$table_large_3_42/Cake.show()
	$table_large_3_43/plate_mp_12.show()
	$Structre/poster_cx_42.change_texture()
	
func _on_bottle_time():
	$table_large_3_42/Bottle.show()
	$table_large_3_43/Bottle.show()
	$Structre/poster_cx_43.change_texture()
