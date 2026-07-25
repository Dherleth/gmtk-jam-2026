extends Control

@onready var home_page: Control = $HomePage
@onready var result: Control = $Result
@onready var searchterm_input: LineEdit = $HomePage/SearchTerm
@onready var searchterm_label: Label = $Result/SearchTerm
@onready var unknown_result: Control = $Result/UnknownResult
@onready var open_4_all_result: Control = $Result/Open4AllResult
@onready var boh_result: Control = $Result/BohResult
@onready var xc_motherload_result: Control = $Result/XcMotherloadResult
@onready var results := [
	unknown_result, open_4_all_result, boh_result, xc_motherload_result
]
@onready var searchterm_to_result := {
		'open4all': {'searchTerm': 'open4all', 'node': open_4_all_result},
		'openforall': {'searchTerm': 'open4all', 'node': open_4_all_result},
		'open for all': {'searchTerm': 'open4all', 'node': open_4_all_result},
		'open 4 all': {'searchTerm': 'open4all', 'node': open_4_all_result},
		
		'B.o.H': {'searchTerm': 'B.o.H', 'node': boh_result},
		'boh': {'searchTerm': 'B.o.H', 'node': boh_result},
		'BOH': {'searchTerm': 'B.o.H', 'node': boh_result},
		'b.o.h': {'searchTerm': 'B.o.H', 'node': boh_result},
		'B.O.H': {'searchTerm': 'B.o.H', 'node': boh_result},
		
		'XC Motherload': {'searchTerm': 'XC Motherload', 'node': xc_motherload_result},
		'xc motherload': {'searchTerm': 'XC Motherload', 'node': xc_motherload_result},
		'xcmotherload': {'searchTerm': 'XC Motherload', 'node': xc_motherload_result},
		'XCMotherload': {'searchTerm': 'XC Motherload', 'node': xc_motherload_result},
		'xc mother load': {'searchTerm': 'XC Motherload', 'node': xc_motherload_result},
		'XC Mother Load': {'searchTerm': 'XC Motherload', 'node': xc_motherload_result},
	}

var searchterm := ""
var history :Array[String] = []

func _ready() -> void:
	result.hide()
	home_page.show()


func _on_search_pressed() -> void:
	history.push_back(searchterm)
	
	for result in results:
		result.hide()
		
	home_page.hide()
	result.show()
		
	if searchterm_to_result.has(searchterm):
		var result = searchterm_to_result[searchterm]
		searchterm_label.text = result.searchTerm
		result.node.show()
		
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
	

func _on_wacky_link_pressed(text: String) -> void:
	searchterm = text
	_on_search_pressed()


func _on_melon_husk_button_wacky_link_pressed(searchTerm: String) -> void:
	_on_wacky_link_pressed(searchTerm)
	
func _on_line_edit_text_submitted(new_text: String) -> void:
	_on_search_pressed()
