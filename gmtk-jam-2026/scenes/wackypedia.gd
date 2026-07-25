extends Control

@onready var home_page: Control = $HomePage
@onready var result: Control = $Result
@onready var searchterm_input: LineEdit = $HomePage/SearchTerm
@onready var recent: Control = $HomePage/Recent
@onready var discovered_pages_container: HBoxContainer = $HomePage/Recent/DiscoveredPages
@onready var searchterm_label: Label = $Result/SearchTerm
@onready var unknown_result: Control = $Result/UnknownResult

@onready var open_4_all_result: Control = $Result/Open4AllResult
@onready var boh_result: Control = $Result/BohResult
@onready var xc_motherload_result: Control = $Result/XcMotherloadResult
@onready var mh_result: Control = $Result/MhResult
@onready var melon_result: Control = $Result/MelonResult
@onready var husk_result: Control = $Result/HuskResult
@onready var mh_businessman_result: Control = $Result/MhBusinessmanResult
@onready var close_b_result: Control = $Result/CloseBResult
@onready var ms_result: Control = $Result/MsResult
@onready var js_result: Control = $Result/JsResult
@onready var anthropomorfik_result: Control = $Result/AnthropomorfikResult


@onready var results := [
	unknown_result, open_4_all_result, boh_result, xc_motherload_result,
	mh_result, melon_result, husk_result, mh_businessman_result, close_b_result,
	ms_result, js_result, anthropomorfik_result
]
@onready var searchterm_to_result := {
		'open4all': {'searchTermLabel': 'open4all', 'node': open_4_all_result},
		'openforall': {'searchTermLabel': 'open4all', 'node': open_4_all_result},
		'open for all': {'searchTermLabel': 'open4all', 'node': open_4_all_result},
		'open 4 all': {'searchTermLabel': 'open4all', 'node': open_4_all_result},
		
		'b.o.h': {'searchTermLabel': 'B.o.H', 'node': boh_result},
		'boh': {'searchTermLabel': 'B.o.H', 'node': boh_result},
		'b o h': {'searchTermLabel': 'B.o.H', 'node': boh_result},
	
		'xc motherload': {'searchTermLabel': 'XC Motherload', 'node': xc_motherload_result},
		'xcmotherload': {'searchTermLabel': 'XC Motherload', 'node': xc_motherload_result},
		'xc mother load': {'searchTermLabel': 'XC Motherload', 'node': xc_motherload_result},
		
		'melon husk': {'searchTermLabel': 'Melon Husk', 'node': mh_result},
		'melonhusk': {'searchTermLabel': 'Melon Husk', 'node': mh_result},
		
		'melon': {'searchTermLabel': 'Melon', 'node': melon_result},
		
		'husk': {'searchTermLabel': 'Husk', 'node': husk_result},
		
		'melon husk (businessman)': {'searchTermLabel': 'Melon Husk (businessman)', 'node': mh_businessman_result},
		
		'closeb$': {'searchTermLabel': 'closeB$', 'node': close_b_result},
		'closeb': {'searchTermLabel': 'closeB$', 'node': close_b_result},
		
		'martin saltman': {'searchTermLabel': 'Martin Saltman', 'node': ms_result},
		'saltman': {'searchTermLabel': 'Martin Saltman', 'node': ms_result},
		
		'john schoolman': {'searchTermLabel': 'John Schoolman', 'node': js_result},
		'schoolman': {'searchTermLabel': 'John Schoolman', 'node': js_result},
		
		'anthropomorfik': {'searchTermLabel': 'Anthropomorfik', 'node': anthropomorfik_result},
	}
@onready var wacky_pedia_buttons := [
		$Result/Open4AllResult/MhButton,
		$Result/Open4AllResult/MsButton,
		$Result/Open4AllResult/JsButton,
		$Result/MhResult/WackyPediaButton,
		$Result/MhResult/WackyPediaButton2,
		$Result/MhResult/WackyPediaButton3,
		$Result/MhBusinessmanResult/WackyPediaButton,
		$Result/MhBusinessmanResult/WackyPediaButton2,
		$Result/CloseBResult/WackyPediaButton,
		$Result/MsResult/WackyPediaButton,
		$Result/MsResult/WackyPediaButton2,
		$Result/MsResult/WackyPediaButton3,
		$Result/JsResult/WackyPediaButton,
		$Result/JsResult/WackyPediaButton2,
		$Result/JsResult/WackyPediaButton3,
		$Result/JsResult/WackyPediaButton4,
		$Result/JsResult/WackyPediaButton5,
		$Result/JsResult/WackyPediaButton6,
		$Result/JsResult/WackyPediaButton7
	]
var wacky_button_scene := preload("res://scenes/WackyPediaButton.tscn")
var searchterm := ""
var history: Array[String] = []
var discovered_pages: Array[String] = []

func _ready() -> void:
	recent.hide()
	result.hide()
	home_page.show()
	for button in wacky_pedia_buttons:
		button.connect("wacky_link_pressed", _on_wacky_link_pressed)


func _on_search_pressed() -> void:
	history.push_back(searchterm)
	
	for result in results:
		result.hide()
		
	home_page.hide()
	result.show()

	if searchterm_to_result.has(searchterm.to_lower()):
		var result = searchterm_to_result[searchterm.to_lower()]
		searchterm_label.text = result.searchTermLabel
		result.node.show()
		
		if not discovered_pages.has(result.searchTermLabel):
			recent.show()
			discovered_pages.push_back(result.searchTermLabel)
			
			var new_wacky_button: WackyPediaButton = wacky_button_scene.instantiate()
			new_wacky_button.search_term = searchterm
			new_wacky_button.text = result.searchTermLabel
			var label := Label.new()
			label.text = result.searchTermLabel
			label.add_theme_font_size_override("font_size", 14)
			label.add_child(new_wacky_button)
			new_wacky_button.wacky_link_pressed.connect(_on_wacky_link_pressed)
		
			discovered_pages_container.add_child(label)
			
	else:
		searchterm_label.text = searchterm
		unknown_result.show()


func _on_line_edit_text_changed(new_text: String) -> void:
	searchterm = new_text


func _on_back_button_pressed() -> void:
	if history.size() == 1:
		history = []
		searchterm_input.text = ""
		result.hide()
		home_page.show()
	else:
		searchterm = history[history.size() - 2]
		history.pop_back()
		history.pop_back() #_on_search_pressed will readd this element
		_on_search_pressed()
	
	
func _on_line_edit_text_submitted(new_text: String) -> void:
	_on_search_pressed()


func _on_wacky_link_pressed(searchTerm: String) -> void:
	self.searchterm = searchTerm
	_on_search_pressed()


func _on_title_pressed() -> void:
	history = []
	searchterm_input.text = ""
	result.hide()
	home_page.show()
