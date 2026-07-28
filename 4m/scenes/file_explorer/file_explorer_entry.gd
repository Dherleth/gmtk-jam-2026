@tool
class_name FileExplorerEntry
extends Resource

enum FileType {
	TEXT,
	IMAGE,
	SOUND,
	FOLDER,
}

const FILE_TYPE_NAMES := {
	FileType.TEXT: "Text File",
	FileType.IMAGE: "Image File",
	FileType.SOUND: "Sound File",
	FileType.FOLDER: "Folder",
}

@export var file_name := "filename.txt":
	set(value):
		if file_name != value:
			file_name = value
			var type_found = false;
			
			for text_type in [".txt", ".doc"]:
				if file_name.to_lower().ends_with(text_type):
					type = FileType.TEXT
					type_found = true
					break
			
			if not type_found:
				for image_type in ["png", "jpg", "jpeg", "gif"]:
					if file_name.to_lower().ends_with(image_type):
						type = FileType.IMAGE
						type_found = true
						break
						
			if not type_found:
				for sound_type in [".mp3", ".wav", ".aac", ".aiff", ".flac"]:
					if file_name.to_lower().ends_with(sound_type):
							type = FileType.SOUND
							type_found = true
							break
					
			if not type_found:
				type = FileType.FOLDER
			
			emit_changed()
@export var modified := "01.01.01":
	set(value):
		if modified != value:
			modified = value
			emit_changed()
@export var type :FileType = FileType.TEXT:
	set(value):
		if type != value:
			type = value
			notify_property_list_changed()
			emit_changed()
@export var size := "1 Ko":
	set(value):
		if size != value:
			size = value
			emit_changed()
@export var folder_content: Array[FileExplorerEntry]:
	set(value):
		_disconnect_children()
		folder_content = value
		_connect_children()
		emit_changed()
@export var target_window: NodePath:
	set(value):
		target_window = value
		emit_changed()


func _validate_property(property: Dictionary) -> void:
	if property.name == "folder_content":
		if type != FileType.FOLDER:
			property.usage |= PROPERTY_USAGE_READ_ONLY # Add read only
		else:
			property.usage &= ~PROPERTY_USAGE_READ_ONLY # Remove read only
	elif property.name == "target_window":
		if type != FileType.FOLDER:
			property.usage &= ~PROPERTY_USAGE_READ_ONLY # Remove read only
		else:
			property.usage |= PROPERTY_USAGE_READ_ONLY # Add read only
	elif property.name == "type":
		property.usage |= PROPERTY_USAGE_READ_ONLY # Add read only
			
			
func _connect_children():
	for child in folder_content:
		if child and !child.changed.is_connected(_on_child_changed):
			child.changed.connect(_on_child_changed)
			

func _disconnect_children():
	for child in folder_content:
		if child and child.changed.is_connected(_on_child_changed):
			child.changed.disconnect(_on_child_changed)
			

func _on_child_changed():
	emit_changed()
