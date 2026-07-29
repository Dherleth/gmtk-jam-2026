@tool
extends MarginContainer
class_name Column

@export var horizontal_alignment: HorizontalAlignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_LEFT:
	set(value):
		horizontal_alignment = value
		if not lines_container:
			lines_container = find_child("LinesContainer")
			
		if lines_container:
			for line: ColumnLine in lines_container.get_children():
				line.horizontal_alignment = horizontal_alignment
			
@export var column_name := "column name":
	set(value):
		column_name = value
		if not column_name_label:
			column_name_label = find_child("ColumnNameLabel")
		
		if column_name_label:
			column_name_label.text = column_name
			
@export var column_name_x_offset := 0.0:
	set(value):
		column_name_x_offset = value
		
		if not column_name_label:
			column_name_label = find_child("ColumnNameLabel")
		
		if column_name_label:
			column_name_label.position.x = column_name_label_base_pos + column_name_x_offset
			
var texture_rect: NinePatchRect
var lines_container: VBoxContainer
var column_name_label: Label
var column_name_label_base_pos = 15
var line_scene = preload("res://scenes/file_explorer/column/line.tscn")
			
			
func add_line(text: String, display_icon := false) -> ColumnLine:
	if not lines_container:
		lines_container = find_child("LinesContainer")
		
	var line_instance: ColumnLine = line_scene.instantiate()
	line_instance.display_icon = display_icon
		
	line_instance.text = text
		
	lines_container.add_child(line_instance)
	
	return line_instance
		
		
func empty() -> void:
	if not lines_container:
		lines_container = find_child("LinesContainer")
	
	for child in lines_container.get_children():
		child.queue_free()
	
