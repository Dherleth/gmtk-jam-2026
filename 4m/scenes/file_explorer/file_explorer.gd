@tool
class_name FileExplorer
extends Control

@export var structure :Array[FileExplorerEntry] = []:
	set(value):
		_disconnect_resources()
		structure = value
		_connect_resources()
		_structure_changed()
		
@onready var window: OsWindow = $Window

var name_column: Column
var modified_column: Column
var type_column: Column
var size_column: Column
var front_lines_container: VBoxContainer # Buttons on top of the lines
var columns_container: HBoxContainer
var back_lines_container: VBoxContainer # Colors behind the lines
var file_system_structure_container: VBoxContainer
var fs_structure_button_scene = preload("res://scenes/file_explorer/file_system_structure_button.tscn")
var current_folder_path_label: Label

var current_folder_path: Array[String] = [] # Work/Important for example, lists only folders
var current_structure_button: FileSystemStructureButton


func _ready() -> void:
	if Engine.is_editor_hint():
		_structure_changed()
	else:
		show()


func _structure_changed() -> void:
	_draw_explorer_content(structure)
	_draw_fs_structure(structure)


func _get_useful_nodes(for_structure := false) -> bool:
	if not for_structure:
		if not columns_container:
			columns_container = find_child("ColumnsContainer")
			
		if not name_column:
			name_column = find_child("NameColumn")
			
		if not modified_column:
			modified_column = find_child("ModifiedColumn")
			
		if not type_column:
			type_column = find_child("TypeColumn")
			
		if not size_column:
			size_column = find_child("SizeColumn")
			
		if not front_lines_container:
			front_lines_container = find_child("FrontLinesContainer")
			
		if not back_lines_container:
			back_lines_container = find_child("BackLinesContainer")
		
		if not current_folder_path_label:
			current_folder_path_label = find_child("PathLabel")
			
		return name_column and modified_column and type_column and size_column and front_lines_container and back_lines_container and current_folder_path_label
	
	if not file_system_structure_container:
		file_system_structure_container = find_child("FileSystemStructureContainer")
		
	if not current_folder_path_label:
		current_folder_path_label = find_child("PathLabel")
		
	return file_system_structure_container and current_folder_path_label

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


func _draw_explorer_content(content: Array[FileExplorerEntry]) -> void:
	if _get_useful_nodes():
		# Removes previous content
		name_column.empty()
		modified_column.empty()
		type_column.empty()
		size_column.empty()
		
		for child in front_lines_container.get_children():
			child.queue_free()
			
		for child in back_lines_container.get_children():
			child.queue_free()
			
		for entry in content:
			if entry:
				var is_folder = entry.type == FileExplorerEntry.FileType.FOLDER
			
				# Populate the columns
				var line_instance = name_column.add_line(entry.file_name, is_folder)
				modified_column.add_line(entry.modified)
				type_column.add_line(FileExplorerEntry.FILE_TYPE_NAMES[entry.type])
				size_column.add_line(entry.size)
				
				# Add button lines over the columns
				var line_button = Button.new()
				front_lines_container.add_child(line_button)
				line_button.custom_minimum_size.y = line_instance.size.y
				line_button.pressed.connect(func(): _on_line_button_pressed(entry))
				line_button.flat = true
				
				# Add colors behind the columns to simulate button interaction
				var line_color = ColorRect.new()
				back_lines_container.add_child(line_color)
				line_color.color = Color("ffffff00")
				line_color.custom_minimum_size.y = line_instance.size.y
				line_button.mouse_entered.connect(func(): _on_line_button_mouse_entered(line_color))
				line_button.mouse_exited.connect(func(): _on_line_button_mouse_exited(line_color))
		
		# Resets the property to notify the new lines to align correctly
		size_column.horizontal_alignment = size_column.horizontal_alignment


func _draw_fs_structure(structure: Array[FileExplorerEntry], deepness := 0, path: Array[String] = []) -> void:
	if _get_useful_nodes(true):
		if deepness == 0: # We are at the beginning so we clean the past version
				for entry in file_system_structure_container.get_children():
					entry.queue_free()

		for entry in structure:
			if entry:
				var is_folder = entry.type == FileExplorerEntry.FileType.FOLDER
				
				# Only display non folders in editor to check our structure
				if is_folder or Engine.is_editor_hint():
					var entry_path := path.duplicate()
					
					if is_folder:
						entry_path.append(entry.file_name)
					
					var button_instance: FileSystemStructureButton = fs_structure_button_scene.instantiate()
					button_instance.display_icon = is_folder
					button_instance.text = entry.file_name
					file_system_structure_container.add_child(button_instance)
					button_instance.deepness = deepness
					button_instance.path = entry_path.duplicate()
					
					if is_folder:
						_draw_fs_structure(entry.folder_content, deepness + 1, entry_path)
						
					button_instance.pressed.connect(func(): _on_fs_structure_button_pressed(button_instance, entry, entry_path))
		
func _on_line_button_pressed(entry: FileExplorerEntry) -> void:
	if entry.type == FileExplorerEntry.FileType.FOLDER:
		current_folder_path.push_back(entry.file_name)
		var current_folder_path_string = "/".join(current_folder_path)
		current_folder_path_label.text = ">://" + current_folder_path_string
		
		for button: FileSystemStructureButton in file_system_structure_container.get_children():
			button.current = "/".join(button.path) == current_folder_path_string
			if button.current:
				current_structure_button = button
			
		_draw_explorer_content(entry.folder_content)
	else:
		if entry.target_window:
			var target_window = get_node(entry.target_window)
			target_window.spawn()
			

func _on_fs_structure_button_pressed(button: FileSystemStructureButton, entry: FileExplorerEntry, path: Array[String]) -> void:
	if entry.type == FileExplorerEntry.FileType.FOLDER:
		current_folder_path = path.duplicate()
		current_folder_path_label.text = ">://" + "/".join(path)
		
		if current_structure_button:
			current_structure_button.current = false
			
		button.current = true
		current_structure_button = button
		_draw_explorer_content(entry.folder_content)
		

func _on_line_button_mouse_entered(color_rect: ColorRect) -> void:
	color_rect.color = Color("afafafff")
	
	
func _on_line_button_mouse_exited(color_rect: ColorRect) -> void:
	color_rect.color = Color("ffffff00")


func get_availables_paths_as_strings() -> Array[String]:
	var availables_paths: Array[String] = []
	
	for button: FileSystemStructureButton in file_system_structure_container.get_children():
		if button.display_icon: # Folder
			availables_paths.push_back("/".join(button.path))

	return availables_paths

func open(path: String):
	for button: FileSystemStructureButton in file_system_structure_container.get_children():
		if path == "/".join(button.path):
			if not window.visible:
				window.spawn()
			button.pressed.emit()
