extends Node2D

@onready var checkpoints_node = $Checkpoints
@onready var racers_node = $Racers
@onready var player = $"Racers/Player"
@onready var laptime = $"Racers/Player/Camera2D/Lap time"
@onready var lapcount = $"Racers/Player/Camera2D/Lap count"
@onready var bestlap = $"Racers/Player/Camera2D/Best lap"
@onready var speed_label = $"Racers/Player/Camera2D/Speed"
@onready var countdown = $Racers/Player/Camera2D/Countdown
@onready var start_timer = $Timers/StartTimer
@onready var show_start_timer = $Timers/ShowStartTimer

var checkpoints: Array[Node] = []
var racers: Array[Node] = []
var tracking: Dictionary = {}
var max_laps = 5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	checkpoints = checkpoints_node.get_children()
	racers = racers_node.get_children()

	for r in racers:
		tracking.get_or_add(r.name, {"sectors": [0, 0, 0], "bestlap": 10 ** 10, "laptimes": [], "lapstart": Time.get_ticks_msec()})
	print(scene_file_path, ' loaded')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	finish_handler()
	labels_handler()
	
	if start_timer.time_left > 4:
		countdown.text = "5"
	elif start_timer.time_left > 3:
		countdown.text = "4"
	elif start_timer.time_left > 2:
		countdown.text = "3"
	elif start_timer.time_left > 1:
		countdown.text = "2"
	elif start_timer.time_left > 0:
		countdown.text = "1"
	else:
		countdown.text = ""
		countdown.hide()
	

func finish_handler():
	if player.lap_count >= max_laps:
		if FileAccess.file_exists('results.txt'):
			var results_file = FileAccess.open('results.txt', FileAccess.READ_WRITE)
			results_file.seek_end(0)
			results_file.store_string('\n' + str(tracking[player.name]['bestlap'] / 1000.0))
			results_file.close()
		get_tree().change_scene_to_file("res://scenes/main_menu/MainMenu.tscn")

func labels_handler():
	lapcount.text = 'Круг: ' + str(max(1, player.lap_count + 1)) + '/' + str(max_laps)
	laptime.text = 'Время круга: ' + str((Time.get_ticks_msec() - tracking[player.name]["lapstart"]) / 1000.0)
	
	if player.lap_count < 1:
		bestlap.text = 'Лучший круг: N/A'
	else:
		bestlap.text = 'Лучший круг: ' + str(tracking[player.name]["bestlap"] / 1000.0)
	
	speed_label.text = str(int(player.speed)) + ' см/с'


# Сигналы
func _on_sector_1_body_entered(body: Node2D) -> void:
	print(body, ' has passed Sector 1')
	var racer = tracking[body.name]
	var checks = racer["sectors"]
	var now = Time.get_ticks_msec()
	var curr_laptime = now - racer["lapstart"]
	
	if body in racers and checks[0] == checks[1] and checks[0] == checks[2]:
		checks[0] += 1
		body.lap_count += 1
		racer["lapstart"] = now
		if body.lap_count != 0:
			racer["laptimes"].append(curr_laptime)
			racer["bestlap"] = min(racer["bestlap"], curr_laptime)
			print("Lap time for ", body.name, " - ", curr_laptime / 1000.0, " seconds")
	print(checks)

func _on_sector_2_body_entered(body: Node2D) -> void:
	print(body, ' has passed Sector 2')
	var racer = tracking[body.name]
	var checks = racer["sectors"]
	if body in racers and checks[0] > checks[1]:
		checks[1] += 1
	print(checks)

func _on_sector_3_body_entered(body: Node2D) -> void:
	print(body, ' has passed Sector 3')
	var racer = tracking[body.name]
	var checks = racer["sectors"]
	if body in racers and checks[1] > checks[2] and checks[0] > checks[2]:
		checks[2] += 1
	print(checks)


func _on_slowdown_area_body_entered(body: Node2D) -> void:
	body.speed_modifier = body.dirt_speed_modifier


func _on_slowdown_area_body_exited(body: Node2D) -> void:
	body.speed_modifier = 1


func _on_slowdown_area_2_body_entered(body: Node2D) -> void:
	body.speed_modifier = body.dirt_speed_modifier


func _on_slowdown_area_2_body_exited(body: Node2D) -> void:
	body.speed_modifier = 1


func _on_start_timer_timeout() -> void:
	player.speed_modifier = 1
	print(player.speed_modifier)
