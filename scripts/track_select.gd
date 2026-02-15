extends Control

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
var selected_track: String = ""
var tracks = {
	1: "res://scenes/levels/bahrain.tscn",
	2: "res://scenes/levels/china.tscn",
	3: "res://scenes/levels/imola.tscn"
}

func _ready():
	$Button_Back.pressed.connect(_on_back_pressed)


func _on_back_pressed():
	MenuButtonSound.play()
	get_tree().change_scene_to_file("res://scenes/main_menu/MainMenu.tscn")


func _on_button_track_1_pressed() -> void:
	GameStartSound.play()
	get_tree().change_scene_to_file(tracks[1])


func _on_button_track_2_pressed() -> void:
	GameStartSound.play()
	get_tree().change_scene_to_file(tracks[2])


func _on_button_track_3_pressed() -> void:
	GameStartSound.play()
	get_tree().change_scene_to_file(tracks[3])


func _on_button_track_random_pressed() -> void:
	GameStartSound.play()
	get_tree().change_scene_to_file(tracks[randi_range(1, 3)])
