extends Control

func ready():
	$ButtonContainer/Button_Start.pressed.connect(_on_button_start_pressed)
	$ButtonContainer/Button_Exit.pressed.connect(_on_button_exit_pressed)
	
func _on_button_start_pressed():
	MenuButtonSound.play()
	get_tree().change_scene_to_file("res://scenes/main_menu/TrackSelection.tscn")

func _on_button_exit_pressed():
	get_tree().quit()
