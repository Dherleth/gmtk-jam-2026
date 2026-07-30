@tool
extends BaseButton

@export var file_explorer: FileExplorer:
	set(value):
		file_explorer = value
		notify_property_list_changed()
		
			
var path := ""

func _get_property_list():
	return [{
		"name": "path",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": ",".join(file_explorer.get_availables_paths_as_strings()),
		"usage": PROPERTY_USAGE_DEFAULT,
	}]

func _get(property):
	if property == "path":
		return path
	return null

func _set(property, value):
	if property == "path":
		path = value
		return true
	return false

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed():
	file_explorer.open(path)
