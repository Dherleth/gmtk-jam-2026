@tool
extends Control
class_name OsWindow

@export var title: String = "Title"
@export var color: Color = Color("ffffff"):
	set(value):
		color = value
		
		if not color_rect:
			color_rect = find_child("Content")
		
		if color_rect:
			color_rect.color = color
		

signal closed
signal opened

var color_rect: ColorRect
var pressed
var mousePos: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		hide()
	$TitleBar/TitleLabel.text = title
	pivot_offset = Vector2(size.x/2, size.y/2)


func _on_gui_input(event: InputEvent) -> void:
	pressed = event.is_pressed()
	var diff = mousePos - get_global_mouse_position()
	mousePos = get_global_mouse_position()
	
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			global_position -= diff
			
			
func _on_x_pressed() -> void:
	despawn()
	
func despawn():
	closed.emit()
	modulate.a = 1.0 # invisible
	pivot_offset.y = size.y # pivot at bottom (for scaling)
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	tween.parallel().tween_property(self, "scale:y", 0.0, 0.2).from(1.5)
	
	# optional, emits the spawned signal once the whole tween is done
	hide()
	
	
func spawn():
	move_to_front()
	modulate.a = 0.0 # invisible
	show()
	pivot_offset.y = size.y # pivot at bottom (for scaling)
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	
	tween.tween_property(self, "modulate:a", 1.0, 0.2)
	tween.parallel().tween_property(self, "scale:y", 1.0, 0.2).from(-1)
	
	tween.tween_callback(opened.emit)
