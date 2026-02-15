extends Control

var selected_track: String = ""

func _ready():
	$GridContainer/Button_Track1.pressed.connect(_on_track_selected.bind("1"))
	$GridContainer/Button_Track2.pressed.connect(_on_track_selected.bind("2"))
	$GridContainer/Button_Track3.pressed.connect(_on_track_selected.bind("3"))
	$GridContainer/Button_TrackRandom.pressed.connect(_on_track_selected.bind(randi_range(1, 3)))

	$Button_Back.pressed.connect(_on_back_pressed)

func _on_track_selected(track_id: String):
	selected_track = track_id
	GameData.selected_track = track_id
	get_tree().change_scene_to_file("res://scenes/snake_select/snake_select.tscn")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu/MainMenu.tscn")
