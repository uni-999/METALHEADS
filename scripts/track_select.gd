extends Control

var selected_track: String = ""

func _ready():
	$Button_Back.pressed.connect(_on_back_pressed)


func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu/MainMenu.tscn")


func _on_button_track_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/bahrain.tscn")


func _on_button_track_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/china.tscn")


func _on_button_track_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/imola.tscn")
