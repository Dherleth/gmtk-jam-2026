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
				if file_name.contains(text_type):
					type = FileType.TEXT
					type_found = true
					break
			
			if not type_found:
				for image_type in ["png", "jpg", "jpeg", "gif"]:
					if file_name.contains(image_type):
						type = FileType.IMAGE
						type_found = true
						break
						
			if not type_found:
				for sound_type in [".mp3", ".wav", ".aac", ".aiff", ".flac"]:
					if file_name.contains(sound_type):
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
		folder_content = value


func _validate_property(property: Dictionary) -> void:
	if property.name == "folder_content":
		if type != FileType.FOLDER:
			property.usage |= PROPERTY_USAGE_READ_ONLY
		else:
			property.usage &= ~PROPERTY_USAGE_READ_ONLY
