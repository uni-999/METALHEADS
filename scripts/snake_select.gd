extends Control

var selected_snake: String = ""

func _ready():
	$GridContainer/Button_Snake1.pressed.connect(_on_snake_selected.bind("1"))
	$GridContainer/Button_Snake2.pressed.connect(_on_snake_selected.bind("2"))
	$GridContainer/Button_Snake3.pressed.connect(_on_snake_selected.bind("2"))
	$GridContainer/Button_SnakeRandom.pressed.connect(_on_snake_selected.bind(randi_range(1, 3)))
	
	$Button_Back.pressed.connect(_on_back_pressed)

func _on_snake_selected(snake_id: String):
	selected_snake = snake_id
	GameData.selected_snake = snake_id
	get_tree().change_scene_to_file("res://scenes/levels/test_lap.tscn")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/track_select/TrackSelection.tscn")
