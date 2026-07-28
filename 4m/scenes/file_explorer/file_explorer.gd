@tool
extends Control

var name_column: Column
var modified_column: Column
var type_column: Column
var size_column: Column

@onready var window: Control = $Window


@export var structure :Array[FileExplorerEntry] = []:
	set(value):
		_disconnect_resources()
		structure = value
		_connect_resources()
		_structure_changed()
		
		
func _ready() -> void:
	if Engine.is_editor_hint():
		_structure_changed()
	else:
		window.spawn()
		

func _structure_changed() -> void:
	print("========================================")
	_print_folder_content(structure)
	print("========================================")
	
	if _get_columns():
		name_column.empty()
		modified_column.empty()
		type_column.empty()
		size_column.empty()
		
		for entry in structure:
			if entry:
				name_column.add_line(entry.file_name, entry.type == FileExplorerEntry.FileType.FOLDER)
				modified_column.add_line(entry.modified)
				type_column.add_line(FileExplorerEntry.FILE_TYPE_NAMES[entry.type])
				size_column.add_line(entry.size)
	

func _get_columns() -> bool:
	if not name_column:
		name_column = find_child("NameColumn")
		
	if not modified_column:
		modified_column = find_child("ModifiedColumn")
		
	if not type_column:
		type_column = find_child("TypeColumn")
		
	if not size_column:
		size_column = find_child("SizeColumn")
		
	return name_column and modified_column and type_column and size_column
		

func _connect_resources():
	for entry in structure:
		if entry and !entry.changed.is_connected(_on_resource_changed):
			entry.changed.connect(_on_resource_changed)
			
			
func _disconnect_resources():
	for entry in structure:
		if entry and entry.changed.is_connected(_on_resource_changed):
			entry.changed.disconnect(_on_resource_changed)
			

func _on_resource_changed():
	_structure_changed()
	

func _print_folder_content(base: Array[FileExplorerEntry], tab := ""):
	for entry in base:
		if entry:
			if entry.type == FileExplorerEntry.FileType.FOLDER:
				var new_tab = tab + "\t"
				print(tab, entry.file_name)
				_print_folder_content(entry.folder_content, new_tab)
			else:
				print(tab, entry.file_name)
