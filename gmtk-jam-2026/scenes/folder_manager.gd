extends Control

@onready var back_button: Button = $"../Root/BackButton"
@onready var work_folder_content: ColorRect = $"../WorkFolderContent"
@onready var important_folder_content: ColorRect = $"../ImportantFolderContent"
@onready var not_important_folder_content: ColorRect = $"../NotImportantFolderContent"
@onready var signed_contracts_folder_content: ColorRect = $"../WorkFolderContent/SignedContractsFolderContent"
@onready var articles_folder_content: ColorRect = $"../WorkFolderContent/ArticlesFolderContent"


var back_goes_to := "root"

func _ready() -> void:
	back_button.hide()
	work_folder_content.hide()
	important_folder_content.hide()
	not_important_folder_content.hide()
	signed_contracts_folder_content.hide()
	articles_folder_content.hide()


func _on_work_button_pressed() -> void:
	work_folder_content.show()
	back_button.show()
	
	
func _on_important_button_pressed() -> void:
	important_folder_content.show()
	back_button.show()
	
	
func _on_not_important_button_pressed() -> void:
	not_important_folder_content.show()
	back_button.show()
	

func _on_signed_contracts_button_pressed() -> void:
	back_goes_to = "work"
	signed_contracts_folder_content.show()
	

func _on_back_button_pressed() -> void:
	match back_goes_to:
		"root":
			back_button.hide()
			work_folder_content.hide()
			important_folder_content.hide()
			not_important_folder_content.hide()
		"work":
			work_folder_content.show()
			signed_contracts_folder_content.hide()
			articles_folder_content.hide()
			back_goes_to = 'root'


func _on_articles_buttons_pressed() -> void:
	back_goes_to = "work"
	articles_folder_content.show()
